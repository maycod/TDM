--Obtiene el listado de actividades.--
PROCEDURE SP_GET_LIST_TASKS(
  c_resultados OUT REF_CURSOR
);

-- Obtiene las tareas en donde el id_userID es el responsable.--
PROCEDURE SP_GET_LIST_TASKS_BY_USER(
  p_userID IN NUMBER,
  c_resultados OUT REF_CURSOR
);

-- Obtiene la tarea en base a su id
PROCEDURE SP_GET_TASK_BY_ID(
  p_taskid IN NUMBER,
  c_resultados OUT REF_CURSOR
);

--Obtiene el listado de todas las actividades.--
PROCEDURE SP_GET_LIST_TASKS(
  c_resultados OUT REF_CURSOR
) IS
BEGIN
  OPEN c_resultados FOR
  SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA, TASK.OBSERVACIONES,
        TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
        TASK.ID_RESPONSABLE
  FROM ADMTDM.TDM_CAT_TAREA TASK
  WHERE TASK.INDICADOR = 1;
EXCEPTION
  WHEN OTHERS THEN
    IF (c_resultados%isOpen) THEN
        CLOSE c_resultados;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
    RAISE;
END;

-- Obtiene las tareas en donde a su id_userID es el responsable.--
PROCEDURE SP_GET_LIST_TASKS_BY_USER(
  id_userID IN NUMBER,
  c_resultados OUT REF_CURSOR
)
BEGIN
  OPEN c_resultados FOR
  SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA, TASK.OBSERVACIONES,
        TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
        TASK.ID_RESPONSABLE
  FROM ADMTDM.TDM_CAT_TAREA TASK
  WHERE TASK.INDICADOR = 1 AND TASK.ID_RESPONSABLE = id_userID;
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
  p_taskid IN NUMBER,
  c_resultados OUT REF_CURSOR
)
BEGIN
  OPEN c_resultados FOR
  SELECT TASK.ID_TAREA, TASK.CVE_TAREA, TASK.DESC_TAREA, TASK.OBSERVACIONES,
        TASK.ID_TIPO_TAREA, TASK.ID_TAREA_PADRE,TASK.NIVEL,
        TASK.ID_RESPONSABLE
  FROM ADMTDM.TDM_CAT_TAREA TASK
  WHERE TASK.INDICADOR = 1 AND TASK.ID_TAREA = p_taskid;
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
    p_tareaId IN NUMBER,
    P_cvetarea in VARCHAR2,
  	p_desctarea IN VARCHAR2,
    p_tipotarea IN NUMBER,
  	p_tareapadre IN NUMBER,
  	P_nivel IN NUMBER,
    P_responsable IN VARCHAR2
);



--Agregar nuevo task
PROCEDURE SP_ADD_TASK(
    p_tareaId IN NUMBER,
    P_cvetarea in VARCHAR2,
  	p_desctarea IN VARCHAR2,
    p_observaciones IN VARCHAR2,
    p_tipotarea IN NUMBER,
  	p_tareapadre IN NUMBER,
  	P_nivel IN NUMBER,
    P_responsable IN VARCHAR2
) IS
    v_id_next_val NUMBER;
BEGIN
  SELECT p_tareaId AS ID_TAREA, p_cvetarea AS CVE_TAREA, p_desctarea AS DESC_TAREA, p_observaciones
    AS OBSERVACIONES, p_tipotarea AS ID_TIPO_TAREA, p_tareapadre AS ID_TAREA_PADRE, p_nivel AS NIVEL, p_responsable AS ID_RESPONSABLE
    FROM TDM_CAT_TAREA


  COALESCE(MAX(ID_USER),0)+1 INTO v_id_next_val FROM SIADM.TDM_CAT_TAREA;
  MERGE INTO SIADM.USERS USR
  USING
  (   SELECT p_tareaId AS ID_TAREA, p_cvetarea AS CVE_TAREA, p_desctarea AS DESC_TAREA, p_observaciones
    AS OBSERVACIONES, p_tipotarea AS ID_TIPO_TAREA, p_tareapadre AS ID_TAREA_PADRE, p_nivel AS NIVEL, p_responsable AS ID_RESPONSABLE
    FROM DUAL) TEMP
  ON
  (  TEMP.ID_USER = USR.ID_USER )
  WHEN MATCHED THEN
      UPDATE SET
          USR.USERNAME = TEMP.USERNAME,
          USR.ID_PROFILE = TEMP.ID_PROFILE,
          USR.USER_MODIFY = TEMP.USER_MODIFY
  WHEN NOT MATCHED THEN
      INSERT (ID_USER, USERNAME, PASSWORD, ID_PROFILE, ACTIVE, USER_MODIFY, CREATION_DATE)
      VALUES( v_id_next_val, TEMP.USERNAME, 'ssitesm', TEMP.ID_PROFILE,  1, null, SYSDATE);

 COMMIT;

EXCEPTION
      WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
          RAISE;
  END;



SP_DEL_TASK
SP_VALIDATE_TASK