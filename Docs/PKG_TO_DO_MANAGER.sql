--**** PKG_TO_DO_MANAGER****
CREATE OR REPLACE PACKAGE TDMADM.PKG_TO_DO_MANAGER AS
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
        c_resultados OUT REF_CURSOR
    );
    
     -- Obtiene usuario en base a su id
    PROCEDURE SP_GET_USER_BY_ID (
        p_id_user IN NUMBER,
        c_resultados OUT REF_CURSOR
    );
    
    -- Agrega nuevo usuario
    PROCEDURE SP_ADD_USER(
        p_userId IN NUMBER,
        p_username IN VARCHAR2,
        p_profileId IN NUMBER,
        p_userModify IN VARCHAR2
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
      p_taskTypeId IN NUMBER,
      p_parentTaskId IN NUMBER,
      p_level IN NUMBER,
      p_responsibleId IN VARCHAR2
    );
    
    END PKG_TO_DO_MANAGER;
  /

    CREATE OR REPLACE PACKAGE BODY TDMADM.PKG_TO_DO_MANAGER AS

    v_error_message VARCHAR2(50) := 'Error, Process wil be aborted';
    
      -- Obtiene listado de usuarios
    PROCEDURE SP_GET_LIST_USERS (
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR
        SELECT USR.ID_USUARIO, USR.CVE_USUARIO, USR.ID_TIPO_USUARIO, PRO.DESC_TIPO_USUARIO ,USR.FECHA_CREACION
        FROM TDMADM.TDM_CAT_USUARIO USR, TDMADM.TDM_CAT_TIPO_USUARIO PRO
        WHERE USR.INDICADOR = 1 AND USR.ID_TIPO_USUARIO = PRO.ID_TIPO_USUARIO;

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
        p_id_user IN NUMBER,
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR
        SELECT USR.ID_USUARIO, USR.CVE_USUARIO,USR.ID_TIPO_USUARIO,PRO.DESC_TIPO_USUARIO ,USR.FECHA_CREACION
        FROM TDMADM.TDM_CAT_USUARIO USR, TDMADM.TDM_CAT_TIPO_USUARIO PRO
        WHERE USR.INDICADOR = 1 AND USR.ID_TIPO_USUARIO = PRO.ID_TIPO_USUARIO
        AND USR.ID_USUARIO= p_id_user;

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
        p_profileId IN NUMBER,
        p_userModify IN VARCHAR2
    ) IS
        v_id_next_val NUMBER;
    BEGIN

        SELECT COALESCE(MAX(ID_USUARIO),0)+1 INTO v_id_next_val FROM TDMADM.TDM_CAT_USUARIO;
        MERGE INTO TDMADM.TDM_CAT_USUARIO USR
        USING
        (   SELECT p_userId AS ID_USUARIO, p_username AS CVE_USUARIO, p_profileId AS ID_TIPO_USUARIO ,p_userModify AS ID_USUARIO_MODIFICACION
            FROM DUAL) TEMP
        ON
        (  TEMP.ID_USUARIO = USR.ID_USUARIO )
        WHEN MATCHED THEN
            UPDATE SET
                USR.CVE_USUARIO = TEMP.CVE_USUARIO,
                USR.ID_TIPO_USUARIO = TEMP.ID_TIPO_USUARIO,
                USR.ID_USUARIO_MODIFICACION = TEMP.ID_USUARIO_MODIFICACION
        WHEN NOT MATCHED THEN
            INSERT (ID_USUARIO, CVE_USUARIO, CONTRASENA, ID_TIPO_USUARIO ,INDICADOR, ID_USUARIO_MODIFICACION, FECHA_CREACION)
            VALUES( v_id_next_val, TEMP.CVE_USUARIO, 'ssitesm', TEMP.ID_TIPO_USUARIO ,1, null, SYSDATE);

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
        UPDATE TDMADM.TDM_CAT_USUARIO SET INDICADOR = 0, ID_USUARIO_MODIFICACION = p_userModify WHERE ID_USUARIO = p_userId;

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
        SELECT PRO.DESC_TIPO_USUARIO
        FROM TDMADM.TDM_CAT_USUARIO USR, TDMADM.TDM_CAT_TIPO_USUARIO PRO
        WHERE USR.INDICADOR = 1 AND USR.ID_TIPO_USUARIO = PRO.ID_TIPO_USUARIO
        AND USR.CVE_USUARIO = p_username AND USR.CONTRASENA = p_password;

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
      SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA, TASK.OBSERVACIONES,
            TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
            TASK.ID_RESPONSABLE
      FROM TDMADM.TDM_CAT_TAREA TASK
      WHERE TASK.INDICADOR = 1;
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
    BEGIN
      OPEN c_resultados FOR
      SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA, TASK.OBSERVACIONES,
            TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
            TASK.ID_RESPONSABLE
      FROM TDMADM.TDM_CAT_TAREA TASK
      WHERE TASK.INDICADOR = 1 AND TASK.ID_RESPONSABLE = p_userId;
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
    BEGIN
      OPEN c_resultados FOR
      SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA, TASK.OBSERVACIONES,
            TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
            TASK.ID_RESPONSABLE
      FROM TDMADM.TDM_CAT_TAREA TASK
      WHERE TASK.INDICADOR = 1 AND TASK.ID_TAREA = p_taskId;
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
      p_taskTypeId IN NUMBER,
      p_parentTaskId IN NUMBER,
      p_level IN NUMBER,
      p_responsibleId IN VARCHAR2
    ) IS
        v_id_next_val NUMBER;
    BEGIN

      SELECT COALESCE(MAX(ID_TAREA),0)+1 INTO v_id_next_val FROM TDMADM.TDM_CAT_TAREA;
      /*MERGE INTO TDMADM.TASKS TSK
      USING
      (   SELECT p_taskId AS ID_TAREA, p_taskName AS CVE_TAREA, p_taskDesc AS DESC_TAREA,
         p_observations AS OBSERVACIONES, p_taskTypeId AS ID_TIPO_TAREA,
         p_parentTaskId AS ID_TAREA_PADRE, p_level AS NIVEL, p_responsibleId AS ID_RESPONSABLE
        FROM DUAL) TEMP
      ON
      (  TEMP.ID_TAREA = TSK.ID_TAREA )
      WHEN MATCHED THEN
          UPDATE SET
              TSK.USERNAME = TEMP.USERNAME,
              TSK.ID_PROFILE = TEMP.ID_PROFILE,
              TSK.USER_MODIFY = TEMP.USER_MODIFY
      WHEN NOT MATCHED THEN
          INSERT (ID_USER, USERNAME, PASSWORD, ID_PROFILE, ACTIVE, USER_MODIFY, CREATION_DATE)
          VALUES( v_id_next_val, TEMP.USERNAME, 'ssitesm', TEMP.ID_PROFILE,  1, null, SYSDATE);

     COMMIT;*/

    EXCEPTION
          WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
              RAISE;
    END;
END PKG_TO_DO_MANAGER;
/
