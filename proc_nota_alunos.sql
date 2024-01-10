--EXEC calculo_media_alunos '01510010259','836X','2022','1'
--EXEC calculo_media_alunos '01490005225','31A1','2022','1'
--EXEC calculo_media_alunos '01640003485','836X','2022','1'

CREATE OR ALTER PROCEDURE [dbo].[calculo_media_alunos](
                                                       @aluno        T_CODIGO,
                                                       @disciplina   T_CODIGO,
                                                       @ano          T_ANO,
                                                       @semestre     T_SEMESTRE2												
                                                       )
AS
BEGIN
--declare @aluno        T_CODIGO ='1490003384'
--declare  @disciplina   T_CODIGO = '36A3'
--declare @ano          T_ANO = 2022
--declare @semestre     T_SEMESTRE2    = 1 
 
DECLARE @CONCEITO_NP1   T_ALFASMALL 
DECLARE	@CONCEITO_NP2   T_ALFASMALL 
DECLARE @CONCEITO_PSUB  T_ALFASMALL
DECLARE @CONCEITO_EX    T_ALFASMALL
DECLARE @MSG            VARCHAR (50)
DECLARE @MF1            T_ALFASMALL
DECLARE @MSUBP1         T_ALFASMALL
DECLARE @MSUBP2         T_ALFASMALL
DECLARE @ME             T_ALFASMALL

SELECT DISTINCT 
 @CONCEITO_NP1 =  (SELECT t.conceito FROM LY_NOTA_HISTMATR T WHERE T.NOTA_ID = 'NP1'  AND T.ALUNO = N.ALUNO AND T.ANO = N.ANO AND T.SEMESTRE = N.SEMESTRE AND T.DISCIPLINA = N.DISCIPLINA) 
,@CONCEITO_NP2 =  (SELECT t.conceito FROM LY_NOTA_HISTMATR T WHERE T.NOTA_ID = 'NP2'  AND T.ALUNO = N.ALUNO AND T.ANO = N.ANO AND T.SEMESTRE = N.SEMESTRE AND T.DISCIPLINA = N.DISCIPLINA) 
,@CONCEITO_PSUB = (SELECT t.conceito FROM LY_NOTA_HISTMATR T WHERE T.NOTA_ID = 'PS'   AND T.ALUNO = N.ALUNO AND T.ANO = N.ANO AND T.SEMESTRE = N.SEMESTRE AND T.DISCIPLINA = N.DISCIPLINA) 
,@CONCEITO_EX =   (SELECT t.conceito FROM LY_NOTA_HISTMATR T WHERE T.NOTA_ID = 'EX'   AND T.ALUNO = N.ALUNO AND T.ANO = N.ANO AND T.SEMESTRE = N.SEMESTRE AND T.DISCIPLINA = N.DISCIPLINA) 

FROM LY_NOTA_HISTMATR N
WHERE  N.ALUNO = @aluno
AND N.NOTA_ID in ( 'NP1','NP2','PS', 'EX')
and N.disciplina =  @disciplina
AND N.ANO =  @ano
and N.semestre =   @semestre

print 'NP1 = '   +    @CONCEITO_NP1
print 'NP2 = '   +    @CONCEITO_NP2
print 'PSUB = '  +    @CONCEITO_PSUB
print 'EX = '    +    @CONCEITO_ex


SET @MF1 = ( ( convert ( decimal(10,2) ,@CONCEITO_NP1 ) + convert ( decimal(10,2) ,@CONCEITO_NP2 ) ) /2)

SET @MSUBP1 = ( ( convert (decimal(10,2) ,@CONCEITO_NP2)  + convert ( decimal(10,2) ,@CONCEITO_PSUB) ) /2 ) 

SET @MSUBP2 = ( ( convert ( decimal(10,2) ,@CONCEITO_NP1) + convert ( decimal(10,2) , @CONCEITO_PSUB) ) /2 )

SET @ME =  (( @MF1 + convert ( decimal(10,2) ,@CONCEITO_EX )) /2 )


	--IF (ISNULL (@CONCEITO_PSUB),0 + @CONCEITO_NP1)

	IF (@CONCEITO_NP1 is NULL)  and  @MSUBP1 >= '6.75' 
		 BEGIN
			SET	@MSG  ='APROVADO'	
			SELECT @MSUBP1 AS MEDIA
			, @MSG AS SITUACAO
			, @disciplina AS DISCIPLINA
			, @ALUNO AS ALUNO 
		 END

		  IF (@CONCEITO_NP1 is NULL)  AND @MSUBP1 < '6.75' 
		  BEGIN
			SET @MSG =  'REPROVADO'		
			SELECT @MSUBP1 AS MEDIA
			, @MSG AS SITUACAO
			, @disciplina AS DISCIPLINA
			, @ALUNO AS ALUNO 
		  END
  
    IF (@CONCEITO_NP2 is NULL) and @MSUBP2  >= '6.75' 
			BEGIN
				SET @MSG =  'APROVADO'
				SELECT @MSUBP2 AS MEDIA
				, @MSG AS SITUACAO
				, @disciplina AS DISCIPLINA
				, @ALUNO AS ALUNO 
			  END 
	IF (@CONCEITO_NP2 is NULL) and @MSUBP2  >= '6.75' 
			BEGIN
				SET @MSG =  'REPROVADO'
				SELECT @MSUBP2 AS MEDIA
				, @MSG AS SITUACAO
				, @disciplina AS DISCIPLINA
				, @ALUNO AS ALUNO 
			  END
			  

	IF @MF1  >=  '6.75' 
    
		  BEGIN
			 SET  @MSG =  'APROVADO'		
			 SELECT @MF1 AS MEDIA  
				 , @MSG AS SITUACAO
				, @disciplina AS DISCIPLINA
				, @ALUNO AS ALUNO 
			 
		  END
	   			
	IF @MF1 < '6.75' 
			BEGIN
				SET @MSG =  'REPROVADO'
				SELECT @MF1 AS MEDIA
				, @MSG AS SITUACAO
				, @disciplina AS DISCIPLINA
				, @ALUNO AS ALUNO 
			 END
			   		 
	IF  @MF1 < '6.75' AND   @ME >= '6.75'     
			   
					BEGIN
						SET @MSG = 'APROVADO'
						SELECT @ME AS MEDIA
						, @MSG AS SITUACAO
						, @disciplina AS DISCIPLINA
						, @ALUNO AS ALUNO 
					END
        		   
    IF   @MF1 < '6.75' AND   @ME < '6.75'
				BEGIN
					   SET @MSG = 'REPROVADO'
					   SELECT @ME AS MEDIA
					   , @MSG AS SITUACAO
						, @disciplina AS DISCIPLINA
						, @ALUNO AS ALUNO 
				END

--  SELECT @MSG AS SITUACAO
--, @disciplina AS DISCIPLINA
--, @ALUNO AS ALUNO 
			 
END				

--COMMIT