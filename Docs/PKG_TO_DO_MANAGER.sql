create or replace PACKAGE TDMADM.PKG_TO_DO_MANAGER IS
 PRAGMA SERIALLY_REUSABLE;
/******************************************************************************
 NAME:       PKG_TO_DO_MANAGER
 PURPOSE:

 REVISIONS:
 Ver        Date        Author           Description
 ---------  ----------  ---------------  ------------------------------------
 1.0        14/04/2016  Manuel Calzaod   1. Created this package.
******************************************************************************/

  TYPE REF_CURSOR IS REF CURSOR;

  -- Obtiene listado de usuarios
  PROCEDURE SP_GET_LIST_USERS (
      p_profileId IN NUMBER,
      c_resultados OUT REF_CURSOR
  );
  
  -- Obtiene usuarios en base a la tarea que esta asignado
  PROCEDURE SP_GET_LIST_USERS_BY_TASK (
      p_taskId IN NUMBER,
      c_resultados OUT REF_CURSOR
  );

  -- Obtiene usuario en base a su id
  PROCEDURE SP_GET_USER_BY_ID (
      p_userId IN NUMBER,
      c_resultados OUT REF_CURSOR
  );
  
  -- Agrega nuevo usuario
  PROCEDURE SP_ADD_USER(
      p_userId IN NUMBER,
      p_username IN VARCHAR2,
      p_codename IN VARCHAR2,
      p_userdesc IN VARCHAR2,
      p_profileId IN NUMBER,
      p_userModify IN VARCHAR2,
      p_active IN NUMBER
  );
  
   -- Inactiva usuario
  PROCEDURE SP_DEL_USER (
      p_userId IN NUMBER,
      p_userModify IN VARCHAR2
  );

  -- Valida si las credenciales son validas
  PROCEDURE SP_VALIDATE_USER (
      p_username IN VARCHAR2,
      p_password IN VARCHAR2,
      c_resultados OUT REF_CURSOR
  );

  -- Actualiza contrasena del usuario
  PROCEDURE SP_UPDATE_USER_PASSWORD(
      p_username IN VARCHAR2,
      p_password IN VARCHAR2
  );
  
  --Obtiene el listado de actividades.--
  PROCEDURE SP_GET_LIST_TASKS(
    c_resultados OUT REF_CURSOR
  );
  
  -- Obtiene las tareas en donde el id_userID es el responsable.--
  PROCEDURE SP_GET_LIST_TASKS_BY_USER(
    p_userId IN NUMBER,
    c_resultados OUT REF_CURSOR
  );

  -- Obtiene la tarea en base a su id
  PROCEDURE SP_GET_TASK_BY_ID(
    p_taskId IN NUMBER,
    c_resultados OUT REF_CURSOR
  );
  
  --Agregar nuevo task
  PROCEDURE SP_ADD_TASK(
    p_taskId IN NUMBER,
    p_taskName in VARCHAR2,
    p_taskDesc IN VARCHAR2,
    p_observations IN VARCHAR2,
    p_parentTaskId IN NUMBER,
    p_responsibleId IN NUMBER,
    p_timeBudget IN NUMBER,
    p_status IN NUMBER,
    p_active IN NUMBER,
    p_userModify IN VARCHAR2
  );

  -- Inactiva usuario
  PROCEDURE SP_DEL_TASK (
      p_taskId IN NUMBER,
      p_userModify IN VARCHAR2
  );

  -- Agrega una asignacion de usuario-tarea
  PROCEDURE SP_ADD_REL_ASG_TASKS (
      p_userId IN NUMBER,
      p_taskId IN NUMBER,
      p_userModify IN VARCHAR2
  );

  -- Elimina una asignacion de usuario-tarea
  PROCEDURE SP_DEL_REL_ASG_TASKS (
      p_userId IN NUMBER,
      p_taskId IN NUMBER,
      p_userModify IN VARCHAR2
  );

  FUNCTION FNC_VALIDATE_TASK(taskId NUMBER) 
  RETURN NUMBER; 
  
  END PKG_TO_DO_MANAGER;
  /
  create or replace PACKAGE BODY        PKG_TO_DO_MANAGER IS
 PRAGMA SERIALLY_REUSABLE;

  v_error_message VARCHAR2(50) := 'Error, Process wil be aborted';
  
    -- Obtiene listado de usuarios
  PROCEDURE SP_GET_LIST_USERS (
      p_profileId IN NUMBER,
      c_resultados OUT REF_CURSOR
  ) IS
  BEGIN
      IF (p_profileId IS NOT NULL) THEN
        OPEN c_resultados FOR
        SELECT USR.ID_USUARIO, USR.CVE_USUARIO,  USR.CVE_RESPONSABLE, USR.DESC_USUARIO, USR.ID_TIPO_USUARIO, PRO.DESC_TIPO_USUARIO ,USR.FECHA_CREACION
        FROM TDMADM.TDM_CAT_USUARIO USR JOIN TDMADM.TDM_CAT_TIPO_USUARIO PRO on USR.ID_TIPO_USUARIO = PRO.ID_TIPO_USUARIO
        WHERE USR.INDICADOR = 1 AND USR.ID_TIPO_USUARIO = p_profileId;
      ELSE
        OPEN c_resultados FOR
        SELECT USR.ID_USUARIO, USR.CVE_USUARIO,  USR.CVE_RESPONSABLE, USR.DESC_USUARIO, USR.ID_TIPO_USUARIO, PRO.DESC_TIPO_USUARIO ,USR.FECHA_CREACION
        FROM TDMADM.TDM_CAT_USUARIO USR JOIN TDMADM.TDM_CAT_TIPO_USUARIO PRO on USR.ID_TIPO_USUARIO = PRO.ID_TIPO_USUARIO
        WHERE USR.INDICADOR = 1;
      END IF;
      

  EXCEPTION
      WHEN OTHERS THEN
          IF (c_resultados%isOpen) THEN
              CLOSE c_resultados;
          END IF;
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;

  -- Obtiene usuario en base a la tarea que esta asignado
  PROCEDURE SP_GET_LIST_USERS_BY_TASK (
      p_taskId IN NUMBER,
      c_resultados OUT REF_CURSOR
  ) IS
      v_level NUMBER;
  BEGIN
      SELECT COALESCE(MAX(NIVEL),0) INTO v_level 
      FROM TDMADM.TDM_CAT_TAREA TSK
      WHERE TSK.ID_TAREA = p_taskId;
      IF (v_level > 2) THEN
        OPEN c_resultados FOR
        SELECT REL_ASG.ID_RESPONSABLE
        FROM TDMADM.TDM_REL_ASIGNACION_TAREAS REL_ASG
        WHERE REL_ASG.ID_TAREA= p_taskId AND REL_ASG.ID_RESPONSABLE IS NOT NULL AND INDICADOR =1;
      ELSE
        OPEN c_resultados FOR
        SELECT TSK.ID_RESPONSABLE FROM TDM_CAT_TAREA TSK WHERE TSK.ID_TAREA = p_taskId AND INDICADOR =1;
      END IF;
  EXCEPTION
      WHEN OTHERS THEN
          IF (c_resultados%isOpen) THEN
              CLOSE c_resultados;
          END IF;
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;
  
    -- Obtiene usuario en base a su id
  PROCEDURE SP_GET_USER_BY_ID (
      p_userId IN NUMBER,
      c_resultados OUT REF_CURSOR
  ) IS
  BEGIN
      OPEN c_resultados FOR
      SELECT USR.ID_USUARIO, USR.DESC_USUARIO, USR.CVE_RESPONSABLE, USR.CVE_USUARIO,
      USR.ID_TIPO_USUARIO,PRO.DESC_TIPO_USUARIO ,USR.FECHA_CREACION, USR.ACTIVO
      FROM TDMADM.TDM_CAT_USUARIO USR, TDMADM.TDM_CAT_TIPO_USUARIO PRO
      WHERE USR.INDICADOR = 1 AND USR.ID_TIPO_USUARIO = PRO.ID_TIPO_USUARIO
      AND USR.ID_USUARIO= p_userId;

  EXCEPTION
      WHEN OTHERS THEN
          IF (c_resultados%isOpen) THEN
              CLOSE c_resultados;
          END IF;
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;

   -- Agrega nuevo usuario
  PROCEDURE SP_ADD_USER (
      p_userId IN NUMBER,
      p_username IN VARCHAR2,
      p_codename IN VARCHAR2,
      p_userdesc IN VARCHAR2,
      p_profileId IN NUMBER,
      p_userModify IN VARCHAR2,
      p_active IN NUMBER
  ) IS
      v_id_next_val NUMBER;
  BEGIN

      SELECT COALESCE(MAX(ID_USUARIO),0)+1 INTO v_id_next_val FROM TDMADM.TDM_CAT_USUARIO;
      MERGE INTO TDMADM.TDM_CAT_USUARIO USR
      USING
      (   SELECT p_userId AS ID_USUARIO, p_username AS CVE_USUARIO, p_profileId AS ID_TIPO_USUARIO,
        p_userModify AS ID_USUARIO_MODIFICACION, p_codename as CVE_RESPONSABLE, p_active as ACTIVO,
        p_userdesc AS DESC_USUARIO
          FROM DUAL) TEMP
      ON
      (  TEMP.ID_USUARIO = USR.ID_USUARIO )
      WHEN MATCHED THEN
          UPDATE SET
              USR.CVE_USUARIO = TEMP.CVE_USUARIO,
              USR.ID_TIPO_USUARIO = TEMP.ID_TIPO_USUARIO,
              USR.ID_USUARIO_MODIFICACION = TEMP.ID_USUARIO_MODIFICACION,
              USR.CVE_RESPONSABLE = TEMP.CVE_RESPONSABLE,
              USR.DESC_USUARIO = TEMP.DESC_USUARIO,
              USR.ACTIVO = TEMP.ACTIVO
      WHEN NOT MATCHED THEN
          INSERT (ID_USUARIO, CVE_USUARIO, CVE_RESPONSABLE,DESC_USUARIO, CONTRASENA, ID_TIPO_USUARIO ,INDICADOR, ACTIVO, ID_USUARIO_MODIFICACION, FECHA_CREACION)
          VALUES( v_id_next_val, TEMP.CVE_USUARIO,TEMP.CVE_RESPONSABLE,TEMP.DESC_USUARIO, '14151035045510542433344112003343555302350532123021', TEMP.ID_TIPO_USUARIO ,1, TEMP.ACTIVO,null, SYSDATE);

     COMMIT;


  EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;
  

   -- Inactiva usuario
  PROCEDURE SP_DEL_USER (
      p_userId IN NUMBER,
      p_userModify IN VARCHAR2
  ) IS
  BEGIN
      UPDATE TDMADM.TDM_CAT_USUARIO SET INDICADOR = 0, ID_USUARIO_MODIFICACION = null WHERE ID_USUARIO = p_userId;

      COMMIT;

  EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;

  -- Valida si las credenciales son validas
  PROCEDURE SP_VALIDATE_USER (
      p_username IN VARCHAR2,
      p_password IN VARCHAR2,
      c_resultados OUT REF_CURSOR
  ) IS
  BEGIN
      OPEN c_resultados FOR
      SELECT PRO.DESC_TIPO_USUARIO, PRO.ID_TIPO_USUARIO, USR.ID_USUARIO
      FROM TDMADM.TDM_CAT_USUARIO USR, TDMADM.TDM_CAT_TIPO_USUARIO PRO
      WHERE USR.INDICADOR = 1 AND USR.ID_TIPO_USUARIO = PRO.ID_TIPO_USUARIO
      AND USR.CVE_USUARIO = p_username AND USR.CONTRASENA = p_password
      AND USR.ID_TIPO_USUARIO IN (1,2);

  EXCEPTION
      WHEN OTHERS THEN
          IF (c_resultados%isOpen) THEN
              CLOSE c_resultados;
          END IF;
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;
  
  -- Actualiza password de usuario
  PROCEDURE SP_UPDATE_USER_PASSWORD(
      p_username IN VARCHAR2,
      p_password IN VARCHAR2
  ) IS
  BEGIN
      UPDATE TDMADM.TDM_CAT_USUARIO SET CONTRASENA = p_password WHERE INDICADOR= 1 AND CVE_USUARIO = p_username;

      COMMIT;

  EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;
  
  --Obtiene el listado de todas las actividades.--
  PROCEDURE SP_GET_LIST_TASKS(
    c_resultados OUT REF_CURSOR
  ) IS
  BEGIN
    OPEN c_resultados FOR
    SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA || CASE 
                                                          WHEN REL_ASG.HORAS_PRESUPUESTO IS NOT NULL 
                                                          THEN ' - ' || REL_ASG.HORAS_PRESUPUESTO END AS DESC_TAREA , TASK.OBSERVACIONES,
          TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
          TASK.ID_RESPONSABLE, TASK.ESTATUS
    FROM(SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA , TASK.OBSERVACIONES,
          TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
          TASK.ID_RESPONSABLE, TASK.ESTATUS
          FROM TDMADM.TDM_CAT_TAREA TASK
          WHERE TASK.INDICADOR = 1 ORDER BY TASK.ID_TAREA ASC) TASK
    LEFT JOIN TDMADM.TDM_REL_ASIGNACION_TAREAS REL_ASG on TASK.ID_TAREA = REL_ASG.ID_TAREA;
  EXCEPTION
    WHEN OTHERS THEN
      IF (c_resultados%isOpen) THEN
          CLOSE c_resultados;
      END IF;
      DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
      RAISE;
  END;
  
  -- Obtiene las tareas en donde a su id_userId es el responsable.--
  PROCEDURE SP_GET_LIST_TASKS_BY_USER(
    p_userId IN NUMBER,
    c_resultados OUT REF_CURSOR
  ) IS
    cursor cursorAux IS SELECT ID_TAREA FROM TDM_CAT_TAREA WHERE ID_RESPONSABLE = p_userId;
  BEGIN
   
    IF (p_userId>1) THEN
      OPEN c_resultados FOR
      SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA || CASE 
                                                          WHEN REL_ASG.HORAS_PRESUPUESTO IS NOT NULL 
                                                          THEN ' - ' || REL_ASG.HORAS_PRESUPUESTO END AS DESC_TAREA , TASK.OBSERVACIONES,
          TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
          TASK.ID_RESPONSABLE, TASK.ESTATUS
    FROM(SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA , TASK.OBSERVACIONES,
          TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
          TASK.ID_RESPONSABLE, TASK.ESTATUS
          FROM TDMADM.TDM_CAT_TAREA TASK
          WHERE TASK.INDICADOR = 1 ORDER BY TASK.ID_TAREA ASC) TASK
    LEFT JOIN TDMADM.TDM_REL_ASIGNACION_TAREAS REL_ASG on TASK.ID_TAREA = REL_ASG.ID_TAREA;
    ELSE
      OPEN c_resultados FOR
      SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA || CASE 
                                                          WHEN REL_ASG.HORAS_PRESUPUESTO IS NOT NULL 
                                                          THEN ' - ' || REL_ASG.HORAS_PRESUPUESTO END AS DESC_TAREA , TASK.OBSERVACIONES,
          TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
          TASK.ID_RESPONSABLE, TASK.ESTATUS
    FROM(SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA , TASK.OBSERVACIONES,
          TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
          TASK.ID_RESPONSABLE, TASK.ESTATUS
          FROM TDMADM.TDM_CAT_TAREA TASK
          WHERE TASK.INDICADOR = 1 ORDER BY TASK.ID_TAREA ASC) TASK
    LEFT JOIN TDMADM.TDM_REL_ASIGNACION_TAREAS REL_ASG on TASK.ID_TAREA = REL_ASG.ID_TAREA;
    END IF;
    
  EXCEPTION
    WHEN OTHERS THEN
      IF (c_resultados%isOpen) THEN
          CLOSE c_resultados;
      END IF;
      DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
      RAISE;
  END;

  -- Obtiene la tarea en base a su id
  PROCEDURE SP_GET_TASK_BY_ID(
    p_taskId IN NUMBER,
    c_resultados OUT REF_CURSOR
  ) IS
    v_level NUMBER;
    v_count NUMBER;
  BEGIN
    SELECT COALESCE(MAX(NIVEL),0) INTO v_level FROM TDMADM.TDM_CAT_TAREA TSK WHERE TSK.ID_TAREA = p_taskId;
    IF (v_level = 2) THEN
    OPEN c_resultados FOR
      SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA, TASK.OBSERVACIONES, TASK.ID_TAREA_PADRE,
            TASK.ID_RESPONSABLE,USR.DESC_USUARIO AS NOMBRE_RESPONSABLE, TASK.ESTATUS, REL_ASG.HORAS_PRESUPUESTO,
            TASK.ACTIVO
      FROM TDMADM.TDM_CAT_TAREA TASK
      LEFT JOIN TDMADM.TDM_REL_ASIGNACION_TAREAS REL_ASG on TASK.ID_TAREA = REL_ASG.ID_TAREA 
      LEFT JOIN TDMADM.TDM_CAT_USUARIO USR ON TASK.ID_RESPONSABLE = USR.ID_USUARIO
      WHERE TASK.INDICADOR = 1 AND TASK.ID_TAREA = p_taskId;
    ELSE
      SELECT COUNT(*) INTO v_count FROM TDMADM.TDM_CAT_TAREA TASK
      LEFT JOIN (SELECT * FROM TDMADM.TDM_REL_ASIGNACION_TAREAS WHERE INDICADOR = 1) REL_ASG on TASK.ID_TAREA = REL_ASG.ID_TAREA 
      LEFT JOIN TDMADM.TDM_CAT_USUARIO USR ON REL_ASG.ID_RESPONSABLE = USR.ID_USUARIO
      WHERE TASK.INDICADOR = 1 AND TASK.ID_TAREA = p_taskId;
      IF (v_count > 1) THEN
        OPEN c_resultados FOR
        SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA, TASK.OBSERVACIONES, TASK.ID_TAREA_PADRE,
              REL_ASG.ID_RESPONSABLE,USR.DESC_USUARIO AS NOMBRE_RESPONSABLE, TASK.ESTATUS, REL_ASG.HORAS_PRESUPUESTO,
              TASK.ACTIVO
        FROM TDMADM.TDM_CAT_TAREA TASK
        LEFT JOIN (SELECT * FROM TDMADM.TDM_REL_ASIGNACION_TAREAS WHERE INDICADOR = 1) REL_ASG on TASK.ID_TAREA = REL_ASG.ID_TAREA 
        LEFT JOIN TDMADM.TDM_CAT_USUARIO USR ON REL_ASG.ID_RESPONSABLE = USR.ID_USUARIO
        WHERE TASK.INDICADOR = 1 AND TASK.ID_TAREA = p_taskId AND REL_ASG.ID_RESPONSABLE IS NOT NULL ;
      ELSE
        OPEN c_resultados FOR
        SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA, TASK.OBSERVACIONES, TASK.ID_TAREA_PADRE,
              REL_ASG.ID_RESPONSABLE,USR.DESC_USUARIO AS NOMBRE_RESPONSABLE, TASK.ESTATUS, REL_ASG.HORAS_PRESUPUESTO,
              TASK.ACTIVO
        FROM TDMADM.TDM_CAT_TAREA TASK
        LEFT JOIN (SELECT * FROM TDMADM.TDM_REL_ASIGNACION_TAREAS WHERE INDICADOR = 1) REL_ASG on TASK.ID_TAREA = REL_ASG.ID_TAREA 
        LEFT JOIN TDMADM.TDM_CAT_USUARIO USR ON REL_ASG.ID_RESPONSABLE = USR.ID_USUARIO
        WHERE TASK.INDICADOR = 1 AND TASK.ID_TAREA = p_taskId;

      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF (c_resultados%isOpen) THEN
          CLOSE c_resultados;
      END IF;
      DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
      RAISE;
  END;
  
   --Agregar nuevo task
  PROCEDURE SP_ADD_TASK(
    p_taskId IN NUMBER,
    p_taskName in VARCHAR2,
    p_taskDesc IN VARCHAR2,
    p_observations IN VARCHAR2,
    p_parentTaskId IN NUMBER,
    p_responsibleId IN NUMBER,
    p_timeBudget IN NUMBER,
    p_status IN NUMBER,
    p_active IN NUMBER,
    p_userModify IN VARCHAR2
  ) IS
      v_id_next_val NUMBER;
      v_id_next_level NUMBER;
      v_id_type_task NUMBER;
      v_id_parent NUMBER;
      v_estatus NUMBER;
      v_level NUMBER;
  BEGIN

    SELECT COALESCE(MAX(ID_TAREA),0)+1 INTO v_id_next_val FROM TDMADM.TDM_CAT_TAREA;
    SELECT COALESCE(MAX(NIVEL),0) + 1 AS NIVEL INTO v_id_next_level FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = p_parentTaskId;
    SELECT COALESCE(MAX(ID_TIPO_TAREA),0) INTO v_id_type_task FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = p_parentTaskId;
    MERGE INTO TDMADM.TDM_CAT_TAREA TSK
    USING
    (   SELECT p_taskId AS ID_TAREA, p_taskName AS CVE_TAREA, p_taskDesc AS DESC_TAREA,
       p_observations AS OBSERVACIONES, p_timeBudget AS HORAS_PRESUPUESTO,
       p_parentTaskId AS ID_TAREA_PADRE, p_responsibleId AS ID_RESPONSABLE, p_active AS ACTIVO
      FROM DUAL) TEMP
    ON
    (  TEMP.ID_TAREA = TSK.ID_TAREA )
    WHEN MATCHED THEN
        UPDATE SET
            TSK.CVE_TAREA = TEMP.CVE_TAREA,
            TSK.DESC_TAREA = TEMP.DESC_TAREA,
            TSK.OBSERVACIONES = TEMP.OBSERVACIONES,
            TSK.ACTIVO = TEMP.ACTIVO
    WHEN NOT MATCHED THEN
        INSERT (ID_TAREA, CVE_TAREA, DESC_TAREA, OBSERVACIONES, ID_TIPO_TAREA, ID_TAREA_PADRE, NIVEL, ID_RESPONSABLE, ACTIVO, ESTATUS, INDICADOR,FECHA_CREACION,ID_USUARIO_CREACION,FECHA_MODIFICACION,ID_USUARIO_MODIFICACION)
        VALUES(v_id_next_val, 'NVO', 'Nueva Tarea', p_observations, v_id_type_task, p_parentTaskId, v_id_next_level,p_responsibleId, p_active,0,1,SYSDATE,null,SYSDATE, null);
    COMMIT;

    MERGE INTO TDMADM.TDM_REL_ASIGNACION_TAREAS REL_ASG
      USING
      (   SELECT p_taskId AS ID_TAREA, p_timeBudget AS HORAS_PRESUPUESTO
        FROM DUAL) TEMP
      ON
      (  TEMP.ID_TAREA= REL_ASG.ID_TAREA )
      WHEN MATCHED THEN
          UPDATE SET
              REL_ASG.HORAS_PRESUPUESTO = TEMP.HORAS_PRESUPUESTO
      WHEN NOT MATCHED THEN
          INSERT (ID_TAREA, INDICADOR,FECHA_CREACION)
          VALUES( v_id_next_val, 1, SYSDATE);
    COMMIT;

    --Get the taskId of the top parent
    IF COALESCE(p_taskId, 0) = 0 THEN 
      SELECT v_id_next_val INTO v_id_parent FROM DUAL;
    ELSE 
      SELECT p_taskId INTO v_id_parent FROM DUAL;
    END IF;
    SELECT COALESCE(MAX(NIVEL),0) INTO v_level FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = v_id_parent;
    WHILE v_level > 2 LOOP
      SELECT COALESCE(MAX(ID_TAREA_PADRE),0) INTO v_id_parent FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = v_id_parent;
      SELECT COALESCE(MAX(NIVEL),0) INTO v_level FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = v_id_parent;
    END LOOP;

    --Validate whole task
    v_estatus := FNC_VALIDATE_TASK(v_id_parent);

  EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
  END;

  -- Inactiva tarea
  PROCEDURE SP_DEL_TASK (
      p_taskId IN NUMBER,
      p_userModify IN VARCHAR2
  ) IS
      v_id_parent NUMBER;
      v_estatus NUMBER;
      v_level NUMBER; 
  BEGIN
      UPDATE TDMADM.TDM_CAT_TAREA SET INDICADOR = 0 WHERE ID_TAREA = p_taskId;
      --Get the taskId of the top parent
      SELECT p_taskId INTO v_id_parent FROM DUAL;
      SELECT COALESCE(MAX(NIVEL),0) INTO v_level FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = v_id_parent;
      WHILE v_level > 2 LOOP
        SELECT COALESCE(MAX(ID_TAREA_PADRE),0) INTO v_id_parent FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = v_id_parent;
        SELECT COALESCE(MAX(NIVEL),0) INTO v_level FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = v_id_parent;
      END LOOP;

      --Validate whole task
      v_estatus := FNC_VALIDATE_TASK(v_id_parent);
      COMMIT;

  EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;

   -- Agrega una asignacion de usuario-tarea
  PROCEDURE SP_ADD_REL_ASG_TASKS (
      p_userId IN NUMBER,
      p_taskId IN NUMBER,
      p_userModify IN VARCHAR2
  ) IS
      v_level NUMBER;
  BEGIN
      SELECT COALESCE(MAX(NIVEL),0) INTO v_level 
      FROM TDMADM.TDM_CAT_TAREA TSK WHERE TSK.ID_TAREA = p_taskId;
      IF (v_level > 2) THEN
        MERGE INTO TDMADM.TDM_REL_ASIGNACION_TAREAS REL_ASG
        USING
        (   SELECT p_taskId AS ID_TAREA, p_userId AS ID_RESPONSABLE
          FROM DUAL) TEMP
        ON
        (  TEMP.ID_TAREA= REL_ASG.ID_TAREA AND
           TEMP.ID_RESPONSABLE= REL_ASG.ID_RESPONSABLE )
        WHEN MATCHED THEN
            UPDATE SET
                REL_ASG.HORAS_PRESUPUESTO = null,
                REL_ASG.HORAS_ESTIMADO = null,
                REL_ASG.HORAS_APLICADAS = null,
                REL_ASG.FECHA_INICIO = null,
                REL_ASG.FECHA_FIN = null,
                REL_ASG.INDICADOR = 1,
                REL_ASG.FECHA_MODIFICACION = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (ID_TAREA,ID_RESPONSABLE, INDICADOR, FECHA_CREACION)
            VALUES( TEMP.ID_TAREA,TEMP.ID_RESPONSABLE, 1, SYSDATE);
      ELSE
        UPDATE TDMADM.TDM_CAT_TAREA SET ID_RESPONSABLE = p_userId WHERE ID_TAREA = p_taskId;
      END IF;
    
    COMMIT;


  EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;

  -- Elimina una asignacion de usuario-tarea
  PROCEDURE SP_DEL_REL_ASG_TASKS (
      p_userId IN NUMBER,
      p_taskId IN NUMBER,
      p_userModify IN VARCHAR2
  ) IS
      v_level NUMBER;
  BEGIN
      SELECT COALESCE(MAX(NIVEL),0) INTO v_level 
      FROM TDMADM.TDM_CAT_TAREA TSK WHERE TSK.ID_TAREA = p_taskId;
      IF (v_level > 2) THEN
        UPDATE TDMADM.TDM_REL_ASIGNACION_TAREAS SET INDICADOR = 0 
        WHERE ID_TAREA = p_taskId AND ID_RESPONSABLE = p_userId;
      ELSE
        UPDATE TDMADM.TDM_CAT_TAREA SET ID_RESPONSABLE = null WHERE ID_TAREA = p_taskId;
      END IF;

      COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
        RAISE;

  END;

  FUNCTION FNC_VALIDATE_TASK(taskId NUMBER) 
    RETURN NUMBER IS 
      v_estatus NUMBER;
      v_parent_time_budget NUMBER;
      v_tasks_time_budget NUMBER;
      v_own_time_budget NUMBER;
      v_level NUMBER;
      v_levelAux NUMBER;
      v_id_parent NUMBER; 
      cursor cursorAux IS
      SELECT  * FROM TDM_CAT_TAREA  WHERE INDICADOR = 1 start with ID_TAREA = taskId
      connect by prior ID_TAREA = ID_TAREA_PADRE
      ORDER BY NIVEL DESC;
      BEGIN
        --Initialization of all tasks with status = 1  
        FOR task IN cursorAux LOOP
          UPDATE TDMADM.TDM_CAT_TAREA SET ESTATUS = 1 WHERE ID_TAREA = task.ID_TAREA;
        END LOOP;

        FOR task IN cursorAux LOOP
          --Total Time Budget of brothers
          SELECT SUM(HORAS_PRESUPUESTO) INTO v_tasks_time_budget FROM TDM_REL_ASIGNACION_TAREAS 
          WHERE ID_TAREA IN (SELECT ID_TAREA FROM TDM_CAT_TAREA 
                              WHERE INDICADOR = 1 AND ID_TAREA_PADRE = task.ID_TAREA_PADRE);

          --Total Time Budget of parent
          SELECT COALESCE(MAX(HORAS_PRESUPUESTO),0) INTO v_parent_time_budget FROM TDM_REL_ASIGNACION_TAREAS 
          WHERE ID_TAREA = task.ID_TAREA_PADRE;
          
          --Own Time Budget
          SELECT COALESCE(MAX(HORAS_PRESUPUESTO),0) INTO v_own_time_budget FROM TDM_REL_ASIGNACION_TAREAS 
          WHERE ID_TAREA = task.ID_TAREA;

          IF (v_tasks_time_budget != v_parent_time_budget AND task.NIVEL > 2 ) OR v_own_time_budget = 0  THEN
            UPDATE TDMADM.TDM_CAT_TAREA SET ESTATUS = 0 WHERE ID_TAREA = task.ID_TAREA;
            SELECT COALESCE(MAX(ID_TAREA),0) INTO v_id_parent FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = task.ID_TAREA_PADRE;
            SELECT COALESCE(MAX(NIVEL),0) INTO v_levelAux FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = task.ID_TAREA_PADRE;
            WHILE v_levelAux > 1 LOOP
              UPDATE TDMADM.TDM_CAT_TAREA SET ESTATUS = 0 WHERE ID_TAREA = v_id_parent;
              SELECT COALESCE(MAX(ID_TAREA_PADRE),0) INTO v_id_parent FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = v_id_parent;
              SELECT COALESCE(MAX(NIVEL),0) INTO v_levelAux FROM TDMADM.TDM_CAT_TAREA WHERE ID_TAREA = v_id_parent;
            END LOOP;     
          END IF;
        END LOOP;
        COMMIT;

        --
        v_estatus := 1;
        RETURN(v_estatus); 
      END; 

END PKG_TO_DO_MANAGER;
/