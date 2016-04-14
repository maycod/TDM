--**** PKG_SISTEMA_INFORMATIVO_SS****
CREATE OR REPLACE PACKAGE SIADM.PKG_SISTEMA_INFORMATIVO_SS AS
/******************************************************************************
   NAME:       PKG_SISTEMA_INFORMATIVO_SS
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14/12/2015  Manuel Calzaod   1. Created this package.
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

    -- Obtiene listado de estudiantes
    PROCEDURE SP_GET_LIST_STUDENTS (
        c_resultados OUT REF_CURSOR
    );

    -- Obtiene estudiante en base a su id
    PROCEDURE SP_GET_STUDENT_BY_ID (
        p_id_student IN NUMBER,
        c_resultados OUT REF_CURSOR
    );

    -- Agrega nuevo estudiante
    PROCEDURE SP_ADD_STUDENT (
        p_studentId IN NUMBER,
        p_studentNumber IN VARCHAR2,
        p_firstName IN VARCHAR2,
        p_lastName IN VARCHAR2,
        p_bachelor IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phoneNumber IN NUMBER,
        p_comments IN VARCHAR2,
        p_userModify IN VARCHAR2
    );

    -- Inactiva estudiante
    PROCEDURE SP_DEL_STUDENT (
        p_studentId IN NUMBER,
        p_userModify IN VARCHAR2
    );

    -- Obtiene listado de grupos estudiantiles
    PROCEDURE SP_GET_LIST_ASSOCIATIONS(
        c_resultados OUT REF_CURSOR
    );

    -- Obtiene grupo estudiantil en base a su id
    PROCEDURE SP_GET_ASSOCIATION_BY_ID (
        p_id_association IN NUMBER,
        c_resultados OUT REF_CURSOR
    );

    -- Agrega nuevo grupo estudiantil
    PROCEDURE SP_ADD_ASSOCIATION(
        p_associationId IN NUMBER,
        p_associationName IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phoneNumber IN NUMBER,
        p_comments IN VARCHAR2,
        p_userModify IN VARCHAR2
    );

    -- Inactiva grupo estudiantil
    PROCEDURE SP_DEL_ASSOCIATION (
        p_associationId IN NUMBER,
        p_userModify IN VARCHAR2
    );

    -- Obtiene listado de proyectos
    PROCEDURE SP_GET_LIST_PROJECTS(
        c_resultados OUT REF_CURSOR
    );

    -- Obtiene grupo estudiantil en base a su id
    PROCEDURE SP_GET_PROJECT_BY_ID (
        p_id_project IN NUMBER,
        c_resultados OUT REF_CURSOR
    );

    -- Agrega nuevo proyecto
    PROCEDURE SP_ADD_PROJECT(
        p_projectId IN NUMBER,
        p_projectName IN VARCHAR2,
        p_projectDesc IN VARCHAR2,
        p_userModify IN VARCHAR2
    );

    -- Inactiva proyecto
    PROCEDURE SP_DEL_PROJECT (
        p_projectId IN NUMBER,
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

    -- Obtiene las asociaciones de un estudiante
    PROCEDURE SP_GET_ASSOC_BY_STU_ID (
        p_id_student IN NUMBER,
        c_resultados OUT REF_CURSOR
    );

    -- Obtiene los estudiantes de un grupo estudiantil
    PROCEDURE SP_GET_STU_BY_ASSOC_ID (
        p_id_association IN NUMBER,
        c_resultados OUT REF_CURSOR
    );

    -- Obtiene los estudiantes y grupos estudiantiles que participan en un proyecto
    PROCEDURE SP_GET_MEMB_BY_PROJ_ID (
        p_id_project IN NUMBER,
        c_resultados OUT REF_CURSOR
    );

    -- Agrega nueva relacion estudiante - grupo estudiantil
    PROCEDURE SP_ADD_REL_STU_ASSOC(
        p_studentId IN NUMBER,
        p_associationId IN NUMBER
    );
    
    -- Elimina relacion estudiante - grupo estudiantil
    PROCEDURE SP_DEL_REL_STU_ASSOC(
        p_studentId IN NUMBER,
        p_associationId IN NUMBER
    );

    -- Obtiene los proyectos en los que participa un miembro
    PROCEDURE SP_GET_PROY_BY_MEMB_ID (
        p_memberId IN NUMBER,
        p_memberType IN NUMBER,
        c_resultados OUT REF_CURSOR
    );

    -- Agrega nueva relacion miembro - proyecto
    PROCEDURE SP_ADD_REL_MEMB_PROJ(
        p_memberId IN NUMBER,
        p_memberType IN NUMBER,
        p_projectId IN NUMBER
    );
    
    -- Elimina  relacion miembro - proyecto
    PROCEDURE SP_DEL_REL_MEMB_PROJ(
        p_memberId IN NUMBER,
        p_memberType IN NUMBER
    );


  END PKG_SISTEMA_INFORMATIVO_SS;
/

CREATE OR REPLACE PACKAGE BODY SIADM.PKG_SISTEMA_INFORMATIVO_SS AS

v_error_message VARCHAR2(50) := 'Error, Process wil be aborted';


    -- Obtiene listado de usuarios
    PROCEDURE SP_GET_LIST_USERS (
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT USR.ID_USER, USR.USERNAME, USR.ID_PROFILE, PRO.DESC_PROFILE, USR.CREATION_DATE 
        FROM SIADM.USERS USR, SIADM.PROFILES PRO 
        WHERE USR.ACTIVE = 1 AND USR.ID_PROFILE = PRO.ID_PROFILE;
    
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
        SELECT USR.ID_USER, USR.USERNAME, USR.ID_PROFILE, PRO.DESC_PROFILE, USR.CREATION_DATE 
        FROM SIADM.USERS USR, SIADM.PROFILES PRO 
        WHERE USR.ACTIVE = 1 AND USR.ID_PROFILE = PRO.ID_PROFILE
        AND USR.ID_USER= p_id_user;
    
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
  
        SELECT COALESCE(MAX(ID_USER),0)+1 INTO v_id_next_val FROM SIADM.USERS;
        MERGE INTO SIADM.USERS USR
        USING
        (   SELECT p_userId AS ID_USER, p_username AS USERNAME, p_profileId AS ID_PROFILE, p_userModify AS USER_MODIFY
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

    -- Inactiva usuario
    PROCEDURE SP_DEL_USER (
        p_userId IN NUMBER,
        p_userModify IN VARCHAR2
    ) IS
    BEGIN
        UPDATE SIADM.USERS SET ACTIVE = 0, USER_MODIFY = p_userModify WHERE ID_USER = p_userId;

        COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Obtiene listado de estudiantes
    PROCEDURE SP_GET_LIST_STUDENTS (
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT ID_STUDENT, STUDENT_NUMBER, FIRST_NAME, LAST_NAME, BACHELOR, EMAIL, PHONE_NUMBER, COMMENTS FROM SIADM.STUDENTS WHERE ACTIVE = 1;
    
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;



    -- Obtiene estudiante en base a su id
    PROCEDURE SP_GET_STUDENT_BY_ID (
        p_id_student IN NUMBER,
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT ID_STUDENT, STUDENT_NUMBER, FIRST_NAME, LAST_NAME, BACHELOR, EMAIL, PHONE_NUMBER, COMMENTS FROM SIADM.STUDENTS WHERE ACTIVE = 1 AND ID_STUDENT = p_id_student ;
    
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

   -- Agrega nuevo estudiante
    PROCEDURE SP_ADD_STUDENT (
        p_studentId IN NUMBER,
        p_studentNumber IN VARCHAR2,
        p_firstName IN VARCHAR2,
        p_lastName IN VARCHAR2,
        p_bachelor IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phoneNumber IN NUMBER,
        p_comments IN VARCHAR2,
        p_userModify IN VARCHAR2
    ) IS 
        v_id_next_val NUMBER;
    BEGIN
  
        SELECT COALESCE(MAX(ID_STUDENT),0)+1 INTO v_id_next_val FROM SIADM.STUDENTS;
        MERGE INTO SIADM.STUDENTS STU
        USING
        (   SELECT p_studentId AS ID_STUDENT, p_studentNumber AS STUDENT_NUMBER, p_firstName AS FIRST_NAME, 
                   p_lastName AS LAST_NAME, p_bachelor AS BACHELOR, p_email AS EMAIL, p_phoneNumber AS PHONE_NUMBER,
                   p_comments AS COMMENTS, p_userModify AS USER_MODIFY
            FROM DUAL) TEMP
        ON
        (  TEMP.ID_STUDENT = STU.ID_STUDENT )
        WHEN MATCHED THEN
            UPDATE SET
                STU.STUDENT_NUMBER = TEMP.STUDENT_NUMBER,
                STU.FIRST_NAME = TEMP.FIRST_NAME,
                STU.LAST_NAME = TEMP.LAST_NAME,
                STU.BACHELOR = TEMP.BACHELOR,
                STU.EMAIL = TEMP.EMAIL,
                STU.PHONE_NUMBER = TEMP.PHONE_NUMBER,
                STU.COMMENTS = TEMP.COMMENTS,
                STU.USER_MODIFY = TEMP.USER_MODIFY
        WHEN NOT MATCHED THEN
            INSERT (ID_STUDENT, STUDENT_NUMBER, FIRST_NAME, LAST_NAME, BACHELOR, EMAIL, PHONE_NUMBER, COMMENTS, ACTIVE, USER_MODIFY, CREATION_DATE)
            VALUES( v_id_next_val, TEMP.STUDENT_NUMBER, TEMP.FIRST_NAME, TEMP.LAST_NAME, TEMP.BACHELOR, TEMP.EMAIL, TEMP.PHONE_NUMBER, TEMP.COMMENTS, 1, null, SYSDATE);

       COMMIT;
     

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Inactiva estudiante
    PROCEDURE SP_DEL_STUDENT(
        p_studentId IN NUMBER,
        p_userModify IN VARCHAR2
    ) IS
    BEGIN
        UPDATE SIADM.STUDENTS SET ACTIVE = 0, USER_MODIFY = p_userModify WHERE ID_STUDENT = p_studentId;

        COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Obtiene listado de asociaciones
    PROCEDURE SP_GET_LIST_ASSOCIATIONS (
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT ID_ASSOCIATION, ASSOCIATION_NAME, EMAIL, PHONE_NUMBER, COMMENTS FROM SIADM.ASSOCIATIONS WHERE ACTIVE = 1;
    
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Obtiene estudiante en base a su id
    PROCEDURE SP_GET_ASSOCIATION_BY_ID (
        p_id_association IN NUMBER,
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT ID_ASSOCIATION, ASSOCIATION_NAME, EMAIL, PHONE_NUMBER, COMMENTS FROM SIADM.ASSOCIATIONS WHERE ACTIVE = 1 AND ID_ASSOCIATION = p_id_association;
    
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Agrega nuevo grupo estudiantil
    PROCEDURE SP_ADD_ASSOCIATION (
        p_associationId IN NUMBER,
        p_associationName IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phoneNumber IN NUMBER,
        p_comments IN VARCHAR2,
        p_userModify IN VARCHAR2
    ) IS 
        v_id_next_val NUMBER;
    BEGIN
  
        SELECT COALESCE(MAX(ID_ASSOCIATION),0)+1 INTO v_id_next_val FROM SIADM.ASSOCIATIONS;
        MERGE INTO SIADM.ASSOCIATIONS ASS
        USING
        (   SELECT  p_associationId AS ID_ASSOCIATION, p_associationName AS ASSOCIATION_NAME, p_email AS EMAIL,
                    p_phoneNumber AS PHONE_NUMBER, p_comments AS COMMENTS, p_userModify AS USER_MODIFY
            FROM DUAL) TEMP
        ON
        (  TEMP.ID_ASSOCIATION = ASS.ID_ASSOCIATION )
        WHEN MATCHED THEN
            UPDATE SET
                ASS.ASSOCIATION_NAME = TEMP.ASSOCIATION_NAME,
                ASS.EMAIL = TEMP.EMAIL,
                ASS.PHONE_NUMBER = TEMP.PHONE_NUMBER,
                ASS.COMMENTS = TEMP.COMMENTS,
                ASS.USER_MODIFY = TEMP.USER_MODIFY
        WHEN NOT MATCHED THEN
            INSERT (ID_ASSOCIATION, ASSOCIATION_NAME, EMAIL, PHONE_NUMBER, COMMENTS, ACTIVE, USER_MODIFY, CREATION_DATE)
            VALUES( v_id_next_val, TEMP.ASSOCIATION_NAME, TEMP.EMAIL, TEMP.PHONE_NUMBER, TEMP.COMMENTS, 1, null, SYSDATE);

       COMMIT;
     

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;


    -- Inactiva grupo estudiantil
    PROCEDURE SP_DEL_ASSOCIATION(
        p_associationId IN NUMBER,
        p_userModify IN VARCHAR2
    ) IS
    BEGIN
        UPDATE SIADM.ASSOCIATIONS SET ACTIVE = 0, USER_MODIFY = p_userModify WHERE ID_ASSOCIATION = p_associationId;

        COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

     -- Obtiene listado de proyectos
    PROCEDURE SP_GET_LIST_PROJECTS (
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT ID_PROJECT, PROJECT_NAME, DESC_PROJECT FROM SIADM.PROJECTS WHERE ACTIVE = 1;
    
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END; 

    -- Obtiene estudiante en base a su id
    PROCEDURE SP_GET_PROJECT_BY_ID (
        p_id_project IN NUMBER,
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT ID_PROJECT, PROJECT_NAME, DESC_PROJECT FROM SIADM.PROJECTS WHERE ACTIVE = 1 AND ID_PROJECT = p_id_project;
    
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Agrega nuevo proyecto
    PROCEDURE SP_ADD_PROJECT(
        p_projectId IN NUMBER,
        p_projectName IN VARCHAR2,
        p_projectDesc IN VARCHAR2,
        p_userModify IN VARCHAR2
    ) IS 
        v_id_next_val NUMBER;
    BEGIN
  
        SELECT COALESCE(MAX(ID_PROJECT),0)+1 INTO v_id_next_val FROM SIADM.PROJECTS;
        MERGE INTO SIADM.PROJECTS PRO
        USING
        (   SELECT  p_projectId AS ID_PROJECT, p_projectName AS PROJECT_NAME, p_projectDesc AS DESC_PROJECT,
                    p_userModify AS USER_MODIFY
            FROM DUAL) TEMP
        ON
        (  TEMP.ID_PROJECT = PRO.ID_PROJECT )
        WHEN MATCHED THEN
            UPDATE SET
                PRO.PROJECT_NAME = TEMP.PROJECT_NAME,
                PRO.DESC_PROJECT = TEMP.DESC_PROJECT,
                PRO.USER_MODIFY = TEMP.USER_MODIFY
        WHEN NOT MATCHED THEN
            INSERT (ID_PROJECT, PROJECT_NAME, DESC_PROJECT, ACTIVE, USER_MODIFY, CREATION_DATE)
            VALUES( v_id_next_val, TEMP.PROJECT_NAME, TEMP.DESC_PROJECT, 1, null, SYSDATE);

       COMMIT;
     

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Inactiva usuario
    PROCEDURE SP_DEL_PROJECT (
        p_projectId IN NUMBER,
        p_userModify IN VARCHAR2
    ) IS
    BEGIN
        UPDATE SIADM.PROJECTS SET ACTIVE = 0, USER_MODIFY = p_userModify WHERE ID_PROJECT = p_projectId;

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
        SELECT PRO.DESC_PROFILE
        FROM SIADM.USERS USR, SIADM.PROFILES PRO
        WHERE ACTIVE = 1 AND USR.ID_PROFILE = PRO.ID_PROFILE
        AND USR.USERNAME = p_username AND USR.PASSWORD = p_password;
    
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
        UPDATE SIADM.USERS SET PASSWORD = p_password WHERE ACTIVE = 1 AND USERNAME = p_username;

        COMMIT;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

     -- Obtiene las asociaciones de un estudiante
    PROCEDURE SP_GET_ASSOC_BY_STU_ID (
        p_id_student IN NUMBER,
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT ASS.ID_ASSOCIATION, ASS.ASSOCIATION_NAME FROM REL_STUDENT_ASSOCIATION RSA, ASSOCIATIONS ASS 
        WHERE RSA.ID_STUDENT = p_id_student AND ASS.ID_ASSOCIATION = RSA.ID_ASSOCIATION
        AND ASS.ACTIVE = 1;    
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Obtiene los estudiantes de un grupo estudiantil
    PROCEDURE SP_GET_STU_BY_ASSOC_ID (
        p_id_association IN NUMBER,
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT STU.ID_STUDENT, STU.FIRST_NAME || ' ' ||STU.LAST_NAME AS STUDENT_NAME 
        FROM REL_STUDENT_ASSOCIATION RSA, STUDENTS STU 
        WHERE RSA.ID_ASSOCIATION = p_id_association AND STU.ID_STUDENT = RSA.ID_STUDENT
        AND STU.ACTIVE = 1;  
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Obtiene los estudiantes y grupos estudiantiles que participan en un proyecto
    PROCEDURE SP_GET_MEMB_BY_PROJ_ID (
        p_id_project IN NUMBER,
        c_resultados OUT REF_CURSOR
    )IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT ID_MEMBER, MEMBER_NAME,ID_MEMBER_TYPE,DESC_MEMBER_TYPE  FROM 
        ((SELECT STU.ID_STUDENT AS ID_MEMBER, STU.FIRST_NAME || ' ' || STU.LAST_NAME AS MEMBER_NAME, RMP.ID_MEMBER_TYPE
        FROM STUDENTS STU JOIN REL_MEMBER_PROJECT RMP ON STU.ID_STUDENT = RMP.ID_MEMBER 
        WHERE RMP.ID_MEMBER_TYPE =1 AND STU.ACTIVE =1 AND RMP.ID_PROJECT = p_id_project)
        UNION ALL
        (SELECT ASS.ID_ASSOCIATION AS ID_MEMBER, ASS.ASSOCIATION_NAME AS MEMBER_NAME, RMP.ID_MEMBER_TYPE
        FROM ASSOCIATIONS ASS JOIN REL_MEMBER_PROJECT RMP ON ASS.ID_ASSOCIATION = RMP.ID_MEMBER 
        WHERE RMP.ID_MEMBER_TYPE =2 AND ASS.ACTIVE =1 AND RMP.ID_PROJECT = p_id_project)) NATURAL JOIN MEMBER_TYPES MT;
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Agrega nueva relacion estudiante - grupo estudiantil
    PROCEDURE SP_ADD_REL_STU_ASSOC(
        p_studentId IN NUMBER,
        p_associationId IN NUMBER
    ) IS 

    BEGIN
  
        INSERT INTO  SIADM.REL_STUDENT_ASSOCIATION(ID_STUDENT, ID_ASSOCIATION)
        SELECT p_studentId, p_associationId FROM DUAL 
        WHERE NOT EXISTS (SELECT 1 FROM  SIADM.REL_STUDENT_ASSOCIATION WHERE ID_STUDENT = p_studentId AND ID_ASSOCIATION = p_associationId);


       COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

    -- Agrega nueva relacion estudiante - grupo estudiantil
    PROCEDURE SP_DEL_REL_STU_ASSOC(
        p_studentId IN NUMBER,
        p_associationId IN NUMBER
    ) IS 

    BEGIN

       DELETE FROM SIADM.REL_STUDENT_ASSOCIATION WHERE ID_STUDENT = p_studentId;
       DELETE FROM SIADM.REL_STUDENT_ASSOCIATION WHERE ID_ASSOCIATION = p_associationId;

       COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;
     

     -- Obtiene los proyectos en los que participa un miembro
    PROCEDURE SP_GET_PROY_BY_MEMB_ID (
        p_memberId IN NUMBER,
        p_memberType IN NUMBER,
        c_resultados OUT REF_CURSOR
    ) IS
    BEGIN
        OPEN c_resultados FOR   
        SELECT ID_PROJECT FROM REL_MEMBER_PROJECT WHERE ID_MEMBER = p_memberId AND ID_MEMBER_TYPE =p_memberType; 
    EXCEPTION
        WHEN OTHERS THEN
            IF (c_resultados%isOpen) THEN
                CLOSE c_resultados;
            END IF;
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;

     -- Agrega nueva relacion miembro - proyecto
    PROCEDURE SP_ADD_REL_MEMB_PROJ(
        p_memberId IN NUMBER,
        p_memberType IN NUMBER,
        p_projectId IN NUMBER
    ) IS 

    BEGIN

       INSERT INTO  SIADM.REL_MEMBER_PROJECT(ID_MEMBER, ID_MEMBER_TYPE, ID_PROJECT)
       SELECT p_memberId, p_memberType, p_projectId FROM DUAL 
       WHERE NOT EXISTS (SELECT 1 FROM  SIADM.REL_MEMBER_PROJECT WHERE ID_MEMBER = p_memberId AND ID_MEMBER_TYPE = p_memberType AND ID_PROJECT = p_projectId);

       COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;
    
    -- Elimina  relacion miembro - proyecto
    PROCEDURE SP_DEL_REL_MEMB_PROJ(
        p_memberId IN NUMBER,
        p_memberType IN NUMBER
    )IS 

    BEGIN

       DELETE FROM SIADM.REL_MEMBER_PROJECT WHERE ID_MEMBER = p_memberId AND ID_MEMBER_TYPE =p_memberType; 

       COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_error_message || SQLCODE || ': ' || SQLERRM);
            RAISE;
    END;


END PKG_SISTEMA_INFORMATIVO_SS;
/


GRANT EXECUTE ON SIADM.PKG_SISTEMA_INFORMATIVO_SS TO SIADM;