use PARC
go
 
IF OBJECT_ID('sp_CSOD_EstrazioneUser')	IS NOT NULL
BEGIN
	DROP PROCEDURE	sp_CSOD_EstrazioneUser
 
	IF OBJECT_ID('sp_CSOD_EstrazioneUser')	IS NOT NULL
		PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp_CSOD_EstrazioneUser >>>'
	ELSE
		PRINT '<<< DROPPED PROCEDURE dbo.sp_CSOD_EstrazioneUser >>>'
END
go
 
create procedure sp_CSOD_EstrazioneUser
as
begin
-- ====================================================================================================
-- Author:		A. Defrancesco
-- Create date: 07/04/2015
-- Description:	La procedura estrae gli utenti (User) per popolare l'applicativo CORNERSTONE
--				Con il termine utenti si intendono sia i soggetti della rete commerciale (agenti)
--				che i dipendenti di sede.
-- ====================================================================================================
	declare @separator char(1)
	
	set @separator = CHAR(9)
	
	truncate table TMP2..USER_CORNERSTONE
	truncate table TMP2..CHANGE_ID_CORNERSTONE

	-- 
	-- Passaggio 1: popolo una tabella temporanea con tutti gli UTENTI
	--
	
	create table #user_out (
		N_ANAG_SOGG						numeric(10,0)
		,COD_SOGGETTO					varchar(10) NULL
		,CodTipoUtente					char(1)				--R = Rete, D = Dipendente, C = Consulente, A = Altro
		,UserID							varchar(100)
		,UserName						varchar(50) NULL
		,Active							varchar(20) NULL
		,Absent							varchar(10) NULL
		,Reconcile						varchar(10) NULL
		,Prefix							varchar(100) NULL
		,FirstName						varchar(50) NULL
		,MiddleName						varchar(50) NULL
		,LastName						varchar(50) NULL
		,Suffix							varchar(100) NULL
		,Email							varchar(100) NULL
		,Phone							varchar(50) NULL
		,Fax							varchar(50) NULL
		,CountryCode					varchar(10) NULL
		,Line1							varchar(100) NULL
		,Line2							varchar(100) NULL
		,City							varchar(100) NULL
		,State_Province					varchar(100) NULL
		,PostalCode						varchar(5) NULL
		,DivisionID						varchar(50) NULL
		,LocationID						varchar(50) NULL
		,PositionID						varchar(50) NULL
		,CostCenterID					varchar(50) NULL
		,GradeID						varchar(50) NULL
		,LastHireDate					varchar(10) NULL
		,OriginalHireDate				varchar(10) NULL
		,RequiredApprovals				varchar(100) NULL
		,ApproverID						varchar(50) NULL
		,ManagerID						varchar(50) NULL
		,Gender							varchar(10) NULL
		,Ethnicity						varchar(100) NULL
		,ClosureDate					varchar(10) NULL
		,Society						varchar(100) NULL
		,TaxCode						varchar(16) NULL
		,TimeZone						varchar(10) NULL
		,Language						varchar(10) NULL
		,TypeContract					varchar(100) NULL
		,Age							varchar(5) NULL
		,BirthDate						varchar(10) NULL
		,ContrattoMandato				varchar(50) NULL
		,ProfiloCandidato				varchar(50) NULL
		,FamigliaProfessionale			varchar(50) NULL
		,SottoFamigliaProfessionale		varchar(50) NULL
		,Qualifica						varchar(50) NULL
		,StatusAssenza					varchar(70) NULL
		,DataInizioAssenza				varchar(10) NULL
		,DataFineAssenza				varchar(10) NULL
		,ConsorzioID					varchar(15) NULL
	)


	insert into #user_out (
		N_ANAG_SOGG
		,COD_SOGGETTO
		,CodTipoUtente
		,UserID
		,UserName
		,Active
		,Absent
		,Reconcile
		,Prefix
		,FirstName
		,MiddleName
		,LastName
		,Suffix
		,Email
		,Phone
		,Fax
		,CountryCode
		,Line1
		,Line2
		,City
		,State_Province
		,PostalCode
		,DivisionID
		,LocationID
		,PositionID
		,CostCenterID
		,GradeID
		,LastHireDate
		,OriginalHireDate
		,RequiredApprovals
		,ApproverID
		,ManagerID
		,Gender
		,Ethnicity
		,ClosureDate
		,Society
		,TaxCode
		,TimeZone
		,Language
		,TypeContract
		,Age
		,BirthDate
		,ContrattoMandato
		,ProfiloCandidato
		,FamigliaProfessionale
		,SottoFamigliaProfessionale
		,Qualifica
		,StatusAssenza
		,DataInizioAssenza
		,DataFineAssenza
		,ConsorzioID
	)
	select	dUser.N_ANAG_SOGG
			,dUser.COD_SOGGETTO
			,dUser.CodTipoUtente
			,dUser.UserID																	--UserID
			, dUser.UserName																--UserName
			, dUser.Active																	--Active
			, dUser.Absent																	--Absent
			, dUser.Reconcile																--Reconcile
			, dUser.Prefix																	--Prefix
			, dUser.FirstName																--FirstName
			, dUser.MiddleName																--MiddleName
			, dUser.LastName																--LastName
			, dUser.Suffix																	--Suffix
			, isNull(dUser.Email, '')														--Email
			, isNull(dUser.Phone, '')														--Phone
			, isNull(dUser.Fax, '')															--Fax
			, dUser.CountryCode																--CountryCode
			, isNull(dUser.Line1, '')														--Line1
			, isNull(dUser.Line2, '')														--Line2
			, isNull(dUser.City, '')														--City
			, isNull(dUser.State_Province, '')												--State_Province
			, isNull(dUser.PostalCode, '')													--PostalCode
			, dUser.DivisionID																--DivisionID
			, case when db_name() = 'PARC' then isNull(dLoc.LocationID, 'I0000000000')
								when db_name() = 'FARC' then isNull(dLoc.LocationID, '0000000000') 
						   end																--LocationID
			, case when db_name() = 'PARC' then isNull(dPos.PositionID, 'I00000')
								when db_name() = 'FARC' then isNull(dPos.PositionID, '00000') 
						   end																--PositionID
			, dUser.CostCenterID															--CostCenterID
			, case when db_name() = 'PARC' then isNull(dGrade.GradeID, 'I00000')
								when db_name() = 'FARC' then isNull(dGrade.GradeID, '00000') 
						   end																--GradeID
			, dUser.LastHireDate															--LastHireDate
			, isNull(dUser.OriginalHireDate, '')											--OriginalHireDate
			, dUser.RequiredApprovals														--RequiredApprovals
			, dUser.ApproverID																--ApproverID
			, isNull(dUser.ManagerID, '')													--ManagerID
			, dUser.Gender																	--Gender
			, dUser.Ethnicity																--Ethnicity
			, isNull(dUser.ClosureDate, '')													--ClosureDate
			--, isNull(dUser.ActiveDetail, '')												--ActiveDetail
			, dUser.Society																	--Society
			, dUser.TaxCode																	--TaxCode
			, dUser.TimeZone																--TimeZone
			, dUser.Language																--Language
			, dUser.TypeContract															--TypeContract
			, dUser.Age																		--Age
			, dUser.BirthDate																--BirthDate
			, dUser.ContrattoMandato														--ContrattoMandato
			, dUser.ProfiloCandidato														--ContrattoMandato
			, dUser.FamigliaProfessionale													--FamigliaProfessionale
			, dUser.SottoFamigliaProfessionale												--SottoFamigliaProfessionale
			, dUser.Qualifica																--Qualifica
			, StatusAssenza																	--StatusAssenza
			, DataInizioAssenza																--DataInizioAssenza
			, DataFineAssenza																--DataFineAssenza
			, dUser.ConsorzioID
	from (
		select	aas.N_ANAG_SOGG
				,aas.COD_SOGGETTO
				,'R' as CodTipoUtente
				,case when db_name() = 'PARC' then aas.COD_SOGGETTO
					when db_name() = 'FARC' then 'F' + right('000000000' + aas.COD_SOGGETTO, 9)
				end  as UserID
				,case when db_name() = 'PARC' then right('0000000000' + aas.COD_SOGGETTO, 10)
					when db_name() = 'FARC' then 'F' + right('000000000' + aas.COD_SOGGETTO, 9)
				end  as UserName
				,case when cast(aas.COD_SOGGETTO as numeric(10, 0)) < 1000 then 'false'
					  when sts.COD_STATO_SOGG = 'ATT' then 'true'
					else 'false'
				end as Active
				,'' as Absent
				,'' as Reconcile
				,'' as Prefix
				,isNull(ltrim(ads.NOME), 'Soggetto ' + 'F' + right('000000000' + aas.COD_SOGGETTO, 9)) as FirstName
				,'' as MiddleName
				,isNull(ltrim(ads.COGNOME), 'Soggetto ' + 'F' + right('000000000' + aas.COD_SOGGETTO, 9)) as LastName
				,'' as Suffix
				,case when ams.E_MAIL not like '%@%.%' then ''
					  when ams.E_MAIL like '%@%.%' then
						  case when (select count(*) FROM ARC_TRASCODIFICA_VALORI where COD_DOMINIO = 'CSOD_EMAIL') > 0 then isNull(atv.VAL_OUT, '')
							else str_replace(ams.E_MAIL, ' ', ltrim(' '))
						  end
				end	as Email
				,ats.TELEFONO AS Phone
				,axs.TELEFONO AS Fax
				,case when db_name() = 'PARC' then 'IT' 
					when db_name() = 'FARC' then 'ES' 
				end  AS CountryCode
				,case when indRes.COMUNE is not NULL then left(indRes.INDIRIZZO, 55) else left(indFisc.INDIRIZZO, 55) end as Line1
				,case when indRes.COMUNE is not NULL then substring(indRes.INDIRIZZO, 56, 55) else substring(indFisc.INDIRIZZO, 56, 55) end as Line2
				,case when indRes.COMUNE is not NULL then left(indRes.COMUNE, 35) else left(indFisc.COMUNE, 35) end as City
				,case when indRes.COMUNE is not NULL then indRes.PROVINCIA else indFisc.PROVINCIA end as State_Province
				,case when indRes.COMUNE is not NULL then indRes.CAP else indFisc.CAP end as PostalCode
				,case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end  + isNull(cast(div.DivisionID as varchar), '00000') as DivisionID
				,case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end  + isNull(afs.COD_FILIALE, '0000000000') as LocationID
				,case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end  + isNull(pos.PositionID, '00000') as PositionID
				,'' as CostCenterID
				,case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end
				+
				case when isNull(incSogg.numIncarichi, 0) > 0 then 'PB'
					when asg.COD_STATO_GIURID = 'ASPFB' then 'AFB'
					else isNull(isNull(ngr.GradeID, gr.GradeID), '00000')
				end as GradeID
				,'' as LastHireDate
				,isNull(convert(varchar, ohDate.OriginalHireDate, 101), '') as OriginalHireDate
				,'0' as RequiredApprovals
				,'' as ApproverID
				,man.ManagerID
				,case	when db_name() = 'PARC' then 
							case when ads.SESSO = 'M' then 'Male'
								else 'Female'
							end
						when db_name() = 'FARC' then 
							case when ads.SESSO = 'M' then 'Female'  -- (M --> Mujer)
								else 'Male'
							end
				end as Gender
			  ,'' as Ethnicity
			  ,case when cDate.ClosureDate is NULL	then ''
					when cDate.ClosureDate > convert(datetime, '16/11/2077', 103)	then '16/11/2077'
					else convert(varchar, cDate.ClosureDate, 101)
			  end as ClosureDate																		--CustomField
			  --,sts.DESCR_STATO_SOGG as ActiveDetail 													--CustomField
			  ,'' as Society																			--CustomField
			  ,ads.COD_FISCALE as TaxCode																--CustomField
			  ,'28' as TimeZone																			--CustomField
			  ,'it-IT' as Language																		--CustomField
			  ,case when asr.N_ANAG_SOGG is NULL then
						(select DESCR_STATO_GIURID
						from ARC_STATO_GIURIDICO
						where COD_STATO_GIURID = 'AAF')
					else asg.DESCR_STATO_GIURID
					end as TypeContract																	--CustomField
			  ,case when isNull(convert(varchar, ads.DT_NASCITA, 101), '01/01/1753') = '01/01/1753'
					then ''
					else isNull(convert(varchar, datediff(year, ads.DT_NASCITA, getdate())), '') 
			   end as Age																			--CustomField
			  ,case when isNull(convert(varchar, ads.DT_NASCITA, 101), '01/01/1753') = '01/01/1753'
					then ''
					else isNull(convert(varchar, ads.DT_NASCITA, 101), '') 
			   end as BirthDate																			--CustomField
			  ,case when ohDate.OriginalHireDate < convert(datetime, '01/01/2013', 103)
					then 'MANDATO_ATTIVO'
					else case when isNull(cut.NUM_CERT, 0) <> 0
							then 'MANDATO_ATTIVO'
							else 'MANDATO_EMESSO'
						 end
			  end as ContrattoMandato																	--CustomField
			,isNull(pCand.ProfiloCandidato, 'NO_TALENT') as ProfiloCandidato							--CustomField
			,'' as FamigliaProfessionale																--CustomField
			,'' as SottoFamigliaProfessionale															--CustomField
			,'' as Qualifica																			--CustomField
			,'NO' as StatusAssenza																		--CustomField
			,'09/01/2017' as DataInizioAssenza															--CustomField, formato mm/dd/yyyy
			,'01/01/2077' as DataFineAssenza															--CustomField, formato mm/dd/yyyy
			,case	when isNull(aco.DT_CHIUSURA_CONSORZIO, dateadd(dd, 1, getdate())) > getdate()
						then isNull(aco.PARTITA_IVA, 'NO_CONSORZIO')
						else 'NO_CONSORZIO'
			end as ConsorzioID																			--New UO ID
		from ARC_ANAG_SOGGETTO aas
		--left join ARC_DIMISSIONI ad on ad.N_ANAG_SOGG = aas.N_ANAG_SOGG and ad.FLG_ANNULLATO = 'N'
		left join ARC_DETT_SOGGETTO ads on ads.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join (
			select amcu.STUD_ID, count(*) as NUM_CERT
			from ARC_MCU_CERTIFICAZIONI_UTENTI amcu
			where amcu.ID_CERTIFICAZIONE in (
				select atv.VAL_OUT 
				from ARC_TRASCODIFICA_VALORI atv
				where atv.COD_DOMINIO = 'CSOD_CERTIFICAZIONI_MANDATO'
			)
			group by amcu.STUD_ID
		) cut on cut.STUD_ID = aas.COD_SOGGETTO
		left join ARC_MAIL_SOGGETTO ams on ams.N_ANAG_SOGG = aas.N_ANAG_SOGG and ams.FLG_ANNULLATO = 'N'
		left join ARC_TRASCODIFICA_VALORI atv on upper(atv.VAL_IN) = upper(ams.E_MAIL) and atv.COD_DOMINIO = 'CSOD_EMAIL'
		left join (
					select ts.*
					from ARC_TELEFONO_SOGGETTO ts
					inner join ARC_TIPO_TELEFONO att on att.N_TIPO_TELEF = ts.N_TIPO_TELEF and att.COD_TIPO_TELEF = 'CELL1'
		) ats on ats.N_ANAG_SOGG = aas.N_ANAG_SOGG and ats.FLG_ANNULLATO = 'N'
		left join (
					select ts.*
					from ARC_TELEFONO_SOGGETTO ts
					inner join ARC_TIPO_TELEFONO att on att.N_TIPO_TELEF = ts.N_TIPO_TELEF and att.COD_TIPO_TELEF = 'FAX'
		) axs on axs.N_ANAG_SOGG = aas.N_ANAG_SOGG and axs.FLG_ANNULLATO = 'N'
		left join ARC_FILIALE_SOGG afs on afs.N_ANAG_SOGG = aas.N_ANAG_SOGG and afs.FLG_ANNULLATO = 'N'
			and convert(datetime, convert(varchar, getdate(),112)) between afs.DT_INIZIO_VALID and afs.DT_FINE_VALID
		left join ARC_CONSORZIO aco on aco.COD_FILIALE = afs.COD_FILIALE
		left join ARC_FILIALE af on af.COD_FILIALE = afs.COD_FILIALE
		left join (
			select ain.N_ANAG_SOGG
				   ,count(*) as numIncarichi
			from ARC_INCARICHI ain
			inner join ARC_TIPO_INCARICO ati ON ati.N_TIPO_INCARICO = ain.N_TIPO_INCARICO
			where ain.FLG_ANNULLATO = 'N'
			and convert(datetime, convert(varchar, getdate(),112)) between isNull(ain.DT_INIZIO_INCARICO, convert(datetime, convert(varchar, getdate(),112))) and isNull(ain.DT_FINE_INCARICO, getdate())
			and ati.COD_TIPO_INCARICO in ('PBINT', 'PBEST')
			group by ain.N_ANAG_SOGG
		) incSogg on incSogg.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join ARC_STRUTTURA_RETE asr on asr.N_ANAG_SOGG = aas.N_ANAG_SOGG and asr.FLG_ANNULLATO = 'N' and asr.COD_TIPO_STRUTT in (0, 2)
		left join ARC_STATO_GIURIDICO asg on asg.N_STATO_GIURID = asr.N_STATO_GIURID and asg.FLG_ANNULLATO = 'N'
		left join ARC_ANAG_SOGGETTO aap on aap.N_ANAG_SOGG = asr.N_ANAG_PADRE and aap.FLG_ANNULLATO = 'N'
		left join ARC_STATO_SOGGETTO sts on sts.N_STATO_SOGG = asr.N_STATO_SOGG
		left join (
			select 	distinct aca.COD_SOGGETTO
					,case when isNull(iter.NOME_ITER, '') = 'WEB RECRUITING'
						 then 'TALENT'
						 else 'NO_TALENT'
					 end as ProfiloCandidato
			from ARC_CANDIDATI_CSOD acc
			inner join ARC_CANDIDATO aca on aca.N_CANDIDATO = acc.N_CANDIDATO
			left join (
				select s1.N_RIFERIMENTO, s1.DT_INIZIO, s2.NOME_ITER
				from (
				select ie.N_RIFERIMENTO, max(ile.DT_INIZIO) DT_INIZIO
				from ARC_ITER ai
				inner join ARC_ITER_LEGAME_ENTITA ile on ile.COD_ITER = ai.COD_ITER  --399563
				inner join ARC_ITER_ENTITA ie ON ie.COD_ENTITA = ile.COD_ENTITA and ie.TIPO = ile.TIPO
				where ile.FLG_ANNULLATO = 'N'
				and ie.FLG_ANNULLATO = 'N'
				group by ie.N_RIFERIMENTO
				) s1
				inner join 
				(
				select ie.N_RIFERIMENTO, DT_INIZIO, ai.NOME_ITER
				from ARC_ITER ai
				inner join ARC_ITER_LEGAME_ENTITA ile on ile.COD_ITER = ai.COD_ITER  --399563
				inner join ARC_ITER_ENTITA ie ON ie.COD_ENTITA = ile.COD_ENTITA and ie.TIPO = ile.TIPO
				where ile.FLG_ANNULLATO = 'N'
				and ie.FLG_ANNULLATO = 'N'
				) s2 on s2.N_RIFERIMENTO = s1.N_RIFERIMENTO and s2.DT_INIZIO = s1.DT_INIZIO
			) iter on iter.N_RIFERIMENTO = aca.N_CANDIDATO
			where isNull(aca.ORIGINE_CANDIDATO, '') <> 'CSOD_CANDIDATI'			
			and aca.FLG_ANNULLATO = 'N'
			union
			select 	distinct aca.COD_SOGGETTO
					,case when apr.COD_PROVENIENZA = '0'
						 then 'TALENT'
						 else 'NO_TALENT'
					 end as ProfiloCandidato
			from ARC_CANDIDATO aca
			inner join ARC_ATTRIBUTI_CANDIDATO aac on aac.N_CANDIDATO = aca.N_CANDIDATO
			inner join ARC_PROVENIENZA apr on apr.N_PROVENIENZA = aac.N_PROVENIENZA
			where isNull(aca.ORIGINE_CANDIDATO, '') = 'CSOD_CANDIDATI'			
			and aca.FLG_ANNULLATO = 'N'
		) pCand on pCand.COD_SOGGETTO = aas.COD_SOGGETTO
		left join (
			select ac.N_ANAG_SOGG
				,'FB_' + ac.COD_PARAMETRO_PROVVIGIONALE as GradeID
			FROM ARC_RUOLI_COMM_SOGG arcs
			inner join ARC_CARRIERA ac on ac.N_ANAG_SOGG = arcs.N_ANAG_SOGG
			inner join ARC_PARAMETRI_PROVVIGIONALI app on app.COD_PARAMETRO = ac.COD_PARAMETRO_PROVVIGIONALE
			where arcs.COD_RUOLO_COMM in ('P', 'GLBAN')
			--and convert(datetime, convert(varchar, getdate(),112)) between app.DT_INIZIO_VALID and app.DT_FINE_VALID
			and convert(datetime, convert(varchar, getdate(),112)) between arcs.DT_INIZIO_RUOLO and arcs.DT_FINE_RUOLO
			and convert(datetime, convert(varchar, getdate(),112)) between ac.DT_INIZIO and ac.DT_FINE
			and arcs.FLG_ANNULLATO = 'N'
			and ac.FLG_ANNULLATO = 'N'
			and app.FLG_ANNULLATO = 'N'
			union
			-- Carriera Manager
			select arcs.N_ANAG_SOGG
					,'MGR_' + arcs.COD_RUOLO_COMM as GradeID
			from ARC_RUOLI_COMM_SOGG arcs
			where arcs.COD_RUOLO_COMM not in ('P', 'GLBAN')
			and convert(datetime, convert(varchar, getdate(),112)) between arcs.DT_INIZIO_RUOLO and arcs.DT_FINE_RUOLO
			and arcs.FLG_ANNULLATO = 'N'
		) gr on gr.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join (
			select atv.VAL_IN as OldGradeID
				   ,atv.VAL_OUT as GradeID
			from ARC_TRASCODIFICA_VALORI atv
			where atv.COD_DOMINIO = 'CSOD_GRADE'
		) ngr on ngr.OldGradeID = gr.GradeID
		left join (
			SELECT agoc.FOGLIA as N_ANAG_SOGG, aes.COD_ETICHETTA DivisionID 
			from ARC_GERARCHIA_ORIZZONTALE_COMM agoc
			left join ARC_ETICHETTA_SOGG aes on aes.N_ANAG_SOGG = isNull(agoc.DIVISIONAL_RIF, agoc.REGIONAL_RIF)
			where aes.FLG_ANNULLATO = 'N'
			AND convert(datetime, convert(varchar, getdate(),112)) between aes.DT_INIZIO_ETICHETTA and aes.DT_FINE_ETICHETTA
		) div on div.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join (
			select sog.N_ANAG_SOGG as N_ANAG_SOGG, convert(varchar(10), AGE_COORD_KEY_I) ManagerID 
			from CEPE..INR_HT_AGE_COMM ht
			inner join ARC_ANAG_SOGGETTO sog on right('0000000000' + sog.COD_SOGGETTO,10) = AGE_KEY_C
			where FLAG_CORRENTE = 'S' 
			and LIV_PROF_DA_COORD = 1
		) man on man.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join (
			select	arcs.N_ANAG_SOGG
					,arcs.COD_RUOLO_COMM as PositionID
			from ARC_RUOLI_COMM_SOGG arcs
			where arcs.FLG_ANNULLATO = 'N'
			and  convert(datetime, convert(varchar, getdate(),112)) between arcs.DT_INIZIO_RUOLO and arcs.DT_FINE_RUOLO
		) pos on pos.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join (
			select ams.N_ANAG_SOGG, min(ams.DT_DECORR_MOV) OriginalHireDate
			from ARC_MOV_STRUTTURA ams
			where ams.FLG_ANNULLATO = 'N'
			group by ams.N_ANAG_SOGG
		) ohDate on ohDate.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join (
			select	ams.N_ANAG_SOGG
					,max(dateadd(dd, -1, ams.DT_DECORR_MOV)) ClosureDate
			from ARC_MOV_STRUTTURA ams
			inner join ARC_STATO_SOGGETTO ass on ass.N_STATO_SOGG = ams.N_STATO_SOGG
			where ass.COD_STATO_SOGG <> 'ATT'
			and ams.FLG_ANNULLATO = 'N'
			and ass.FLG_ANNULLATO = 'N' 
			group by ams.N_ANAG_SOGG
		) cDate on cDate.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join (
			select	ais.N_ANAG_SOGG
					,ais.COMUNE
					,ais.CAP
					,ais.PROVINCIA
					,ais.INDIRIZZO
			from  ARC_INDIRIZZO_SOGGETTO ais
			inner join ARC_TIPO_INDIRIZZO ati on ati.N_TIPO_INDIR = ais.N_TIPO_INDIR
			where ati.COD_TIPO_INDIR ='RES' 
			and getdate() between ais.DT_INIZIO_VALID and ais.DT_FINE_VALID 
			and ais.FLG_ANNULLATO = 'N' 
			and ati.FLG_ANNULLATO = 'N' 
		) indRes on indRes.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join (
			select	ais.N_ANAG_SOGG
					,ais.COMUNE
					,ais.CAP
					,ais.PROVINCIA
					,ais.INDIRIZZO
			from  ARC_INDIRIZZO_SOGGETTO ais
			inner join ARC_TIPO_INDIRIZZO ati ON ati.N_TIPO_INDIR = ais.N_TIPO_INDIR
			where ati.COD_TIPO_INDIR ='DFISC' 
			and getdate() between ais.DT_INIZIO_VALID and ais.DT_FINE_VALID 
			and ais.FLG_ANNULLATO = 'N' 
			and ati.FLG_ANNULLATO = 'N' 
		) indFisc ON indFisc.N_ANAG_SOGG = aas.N_ANAG_SOGG
		where aas.FLG_ANNULLATO = 'N'
		and aas.COD_SOGGETTO not in (
			select cast(cast(agd.AGE_C_AGE as numeric) as varchar)
			from TMP2..ARC_AGENTI_DEMO agd
			where agd.FLG_ANNULLATO = 'N'
		)
		union
		select	-1 as N_ANAG_SOGG
				,NULL as COD_SOGGETTO
				,case when aad.TIPO_ASSUNZIONE = 'D' then 'D'
					  when aad.TIPO_ASSUNZIONE = 'C' then 'C'
					  else 'A'
				end as CodTipoUtente
				,aad.STUD_ID as UserID
				,aad.STUD_ID as UserName
				,case when isNull(aad.DT_CESSAZIONE, dateadd(dd, 1, getdate())) < getdate()
					THEN 'false'
					ELSE
						CASE WHEN aad.STATO_RAPPORTO = '1'
							then 'true'
							else 'false'
						END
				end as Active
				,'' as Absent
				,'' as Reconcile
				,'' as Prefix
				,aad.NOME as FirstName
				,'' as MiddleName
				,aad.COGNOME as LastName
				,'' as Suffix
				,case when aad.E_MAIL not like '%@%.%'
					then '' 
					else str_replace(aad.E_MAIL, ' ', ltrim(' '))
				end	as Email
				,'' as Phone
				,'' as Fax
				,case when db_name() = 'PARC' then 'IT' 
					when db_name() = 'FARC' then 'ES' 
				end as CountryCode
				,'' as Line1
				,'' as Line2
				,'' as City
				,'' as State_Province
				,'' as PostalCode
				,case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end + isNull(ard.COD_REPARTO, '00000') as DivisionID
				,case when db_name() = 'PARC' then 'ISEDE' 
					when db_name() = 'FARC' then '0000000000'
				end as LocationID
				,case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end + '00000' as PositionID
				,'' as CostCenterID
				,case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end  + '00000' as GradeID
				,'' as LastHireDate
				,IsNull(convert(varchar, aad.DT_ASSUNZIONE, 101), '') as OriginalHireDate
				,'0' as RequiredApprovals
				,'' as ApproverID
				,case when IsNull(isNull(trd.VAL_OUT, ard.RESPONSABILE_REPARTO), aad.STUD_ID) = aad.STUD_ID
						then isNull(trds.VAL_OUT, ards.RESPONSABILE_REPARTO)
						else isNull(trd.VAL_OUT, ard.RESPONSABILE_REPARTO)
				end as ManagerID
				,case when cast(substring(aad.COD_FISCALE, 10, 2) as int) > 40
					then 'Female'
					else 'Male'
				end as Gender
				,'' as Ethnicity
				,case when aad.DT_CESSAZIONE is NULL	then ''
						when aad.DT_CESSAZIONE > convert(datetime, '01/01/2077', 103)	then '01/01/2077'
						else convert(varchar, aad.DT_CESSAZIONE, 101)
				end as ClosureDate																	--CustomField
				--,case when STATO_RAPPORTO = '1'
				--	then 'ATTIVO'
				--	else 'DIMESSO'
				--end as ActiveDetail																--CustomField
				,aad.SOCIETA as Society																--CustomField
				,aad.COD_FISCALE as TaxCode															--CustomField
				,'28' as TimeZone																	--CustomField
				,'it-IT' as Language																--CustomField
				,isNull(aat.DESCRIZIONE, '') as TypeContract										--CustomField
				--,'' as TypeContract																--CustomField
				,isNull(convert(varchar, datediff(year, dbo.sf_cf2date(aad.COD_FISCALE, getdate()), getdate())), '') as Age		--CustomField
				,isNull(convert(varchar, dbo.sf_cf2date(aad.COD_FISCALE, getdate()), 101), '') as BirthDate							--CustomField
				,'NON_APPLICABILE' as ContrattoMandato												--CustomField
				,'NON_APPLICABILE' as ProfiloCandidato												--CustomField
				,afp.DES_FAMIGLIAPROFESSIONALE as FamigliaProfessionale								--CustomField
				,asp.DES_SOTTOFAMIGLIAPROFESSIONALE as SottoFamigliaProfessionale					--CustomField
				,aaq.DESCR_QUALIFICA as Qualifica													--CustomField
				,case	when adm.STATUS_ASSENZA is NULL then 'NO'
						when datediff(dd, getdate(), adm.DATA_FINE_ASSENZA)  < 0 then 'NO'
						else adm.STATUS_ASSENZA + ' - ' + aaa.DES_ASSENZA
				end as StatusAssenza
				,case	when adm.STATUS_ASSENZA is NULL then convert(varchar, getdate(), 101)
						when datediff(dd, getdate(), adm.DATA_FINE_ASSENZA)  < 0 then convert(varchar, getdate(), 101)
						else convert(varchar, adm.DATA_INIZIO_ASSENZA, 101)
				end as DataInizioAssenza
				,case	when adm.STATUS_ASSENZA is NULL then  '01/01/2077'
						when datediff(dd, getdate(), adm.DATA_FINE_ASSENZA)  < 0 then '01/01/2077'
						else convert(varchar, adm.DATA_FINE_ASSENZA, 101)
				end as DataFineAssenza
				,'NO_CONSORZIO' as ConsorzioID														--New UO ID
		from ARC_ANAG_DIPENDENTI aad
		inner JOIN (
			SELECT upper(STUD_ID) STUD_ID, max(DT_ASSUNZIONE) DT_ASSUNZIONE
			from ARC_ANAG_DIPENDENTI
			GROUP BY upper(STUD_ID)
		) maad ON maad.STUD_ID = upper(aad.STUD_ID) AND maad.DT_ASSUNZIONE = aad.DT_ASSUNZIONE
		left join ARC_REPARTI_DIPENDENTI ard on ard.COD_REPARTO = aad.COD_REPARTO
		left join ARC_REPARTI_DIPENDENTI ards on ards.COD_REPARTO = ard.COD_REPARTO_SUP
		left join ARC_ATTUALE_P_TRASC aat on aat.CODICE = aad.TIPO_RAPPORTO
		left join ARC_TRASCODIFICA_VALORI trd on trd.COD_DOMINIO = 'CSOD_MANAGER' and trd.VAL_IN = ard.RESPONSABILE_REPARTO
		left join ARC_TRASCODIFICA_VALORI trds on trds.COD_DOMINIO = 'CSOD_MANAGER' and trds.VAL_IN = ards.RESPONSABILE_REPARTO
		left join ARC_TIPO_FAMIGLIAPROFESSIONALE afp on afp.COD_FAMIGLIAPROFESSIONALE = aad.COD_FAMIGLIAPROFESSIONALE
		left join ARC_TIPO_SOTTOFAMIGLIAPROFESSIONALE asp on asp.COD_SOTTOFAMIGLIAPROFESSIONALE = aad.COD_SOTTOFAMIGLIAPROFESSIONALE
		left join ARC_QUALIFICHE_DIPENDENTI aqd on aqd.STUD_ID = aad.STUD_ID
		left join ARC_ANAG_QUALIFICHE aaq on aaq.COD_QUALIFICA = aqd.COD_QUALIFICA
		left join ARC_ANAG_DIPENDENTI_MEDI adm on adm.STUD_ID = aad.STUD_ID
		left join ARC_ANAG_ASSENZE aaa on aaa.COD_ASSENZA = adm.STATUS_ASSENZA
		where (aad.TIPO_ASSUNZIONE = 'D' or aad.RESPONSABILE = 'S')
		or (aad.TIPO_ASSUNZIONE = 'C' and upper(aad.SOCIETA) in ('COMDATA', 'INFORGROUP S.P.A.'))
		union
		select	-2 as N_ANAG_SOGG
				,NULL as COD_SOGGETTO
				,'A' as CodTipoUtente
				,'1000000000' as UserID
				,'1000000000' as UserName
				,'true' as Active
				,'' as Absent
				,'' as Reconcile
				,'' as Prefix
				,'UTENTE FITTIZIO' as FirstName
				,'' as MiddleName
				,'UTENTE FITTIZIO' as LastName
				,'' as Suffix
				,'' as Email
				,'' as Phone
				,'' AS Fax
				,'IT' as CountryCode
				,'' as Line1
				,'' as Line2
				,'MILANO' as City
				,'MI' as State_Province
				,'20100' as PostalCode
				,'I00000' as DivisionID
				,'I0000000000' as LocationID
				,'I00000' as PositionID
				,'' as CostCenterID
				,'I00000' as GradeID
				,'' as LastHireDate
				,'' as OriginalHireDate
				,'0' as RequiredApprovals
				,'' as ApproverID
				,'' as ManagerID
				,'Male' as Gender
				,'' as Ethnicity
				,'' as ClosureDate						--CustomField 
				--,'ATTIVO' as ActiveDetail				--CustomField 
				,'' as Society							--CustomField
				,'' as TaxCode							--CustomField
				,'28' as TimeZone						--CustomField
				,'it-IT' as Language					--CustomField
				,'' as TypeContract						--CustomField
				,'' as Age								--CustomField
				,'' as BirthDate						--CustomField
				,'NON_APPLICABILE' as ContrattoMandato	--CustomField
				,'NON_APPLICABILE' as ProfiloCandidato	--CustomField
				,'' as FamigliaProfessionale
				,'' as SottoFamigliaProfessionale
				,'' as Qualifica
				,'NO' as StatusAssenza
				,'09/01/2017' as DataInizioAssenza		--CustomField, formato mm/dd/yyyy
				,'01/01/2077' as DataFineAssenza		--CustomField, formato mm/dd/yyyy
				,'NO_CONSORZIO' as ConsorzioID			--New UO ID
	) dUser
	left join (
		select	case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end  + af.COD_FILIALE as LocationID
		from ARC_FILIALE af
		left join ARC_ANAG_SOGGETTO ans on ans.N_ANAG_SOGG = af.N_ANAG_SOGG and ans.FLG_ANNULLATO = 'N'
		where af.FLG_ANNULLATO = 'N'
		union
		select case when db_name() = 'PARC' then 'ISEDE'
					when db_name() = 'FARC' then NULL 
				end  as LocationID
		union
		select case when db_name() = 'PARC' then 'I0000000000' 
					when db_name() = 'FARC' then NULL 
				end  as LocationID
	) dLoc on dLoc.LocationID = dUser.LocationID
	left join (
		select 	case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end + arc.COD_RUOLO_COMM as PositionID
		from ARC_RUOLI_COMM arc
		where  arc.FLG_ANNULLATO = 'N'
		union
		select	case when db_name() = 'PARC' then 'I00000' 
					when db_name() = 'FARC' then ''
				end as PositionID
		union
		select	case when db_name() = 'PARC' then 'BANCA_MED'
					when db_name() = 'FARC' then ''
				end as PositionID
		union
		select	case when db_name() = 'PARC' then 'GRUPPO_MED'
					when db_name() = 'FARC' then ''
				end as PositionID
	) dPos on dPos.PositionID = dUser.PositionID
	left join (
		select	case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end + 'FB_' + COD_PARAMETRO as GradeID
		from ARC_PARAMETRI_PROVVIGIONALI app
		where app.FLG_ANNULLATO = 'N' 
		union
		select	case when db_name() = 'PARC' then 'I' 
					when db_name() = 'FARC' then '' 
				end + 'MGR_' + arc.COD_RUOLO_COMM as GradeID
		from ARC_RUOLI_COMM arc
		where arc.FLG_ANNULLATO = 'N'
		union
		select	case when db_name() = 'PARC' then 'I00000' 
					when db_name() = 'FARC' then '' 
				end as GradeID
		union
		select	case when db_name() = 'PARC' then 'IAFB' 
					when db_name() = 'FARC' then '' 
				end as GradeID
		union
		select	case when db_name() = 'PARC' then 'IPB'
					when db_name() = 'FARC' then '' 
				end as GradeID
		union
		select	case when db_name() = 'PARC' then 'IMPB'
					when db_name() = 'FARC' then '' 
				end as GradeID
		union
		select	case when db_name() = 'PARC' then 'IMGR'
					when db_name() = 'FARC' then '' 
				end as GradeID
		union
		select	case when db_name() = 'PARC' then 'IFB'
					when db_name() = 'FARC' then '' 
				end as GradeID
		union
		select	case when db_name() = 'PARC' then 'BANCA_MED' 
					when db_name() = 'FARC' then '' 
				end as GradeID
		union
		select	case when db_name() = 'PARC' then 'GRUPPO_MED' 
					when db_name() = 'FARC' then '' 
				end as GradeID
	) dGrade on dGrade.GradeID = dUser.GradeID


	-- 
	-- Gli utenti di Rete, attivi, senza Divisional e senza Regional sono rimappati sul National Italia
	--
	update #user_out
	set DivisionID = 'REG_ITA'
	from #user_out uo
	inner join ARC_GERARCHIA_ORIZZONTALE_COMM agoc on agoc.FOGLIA = uo.N_ANAG_SOGG
	where CodTipoUtente = 'R'
	and uo.Active = 'true'
	and agoc.DIVISIONAL_RIF is NULL
	and agoc.REGIONAL_RIF is NULL


	-- 
	-- Passaggio 2: popolo una tabella temporanea con tutti i CANDIDATI
	--
	
	create table #candidati_out (
		N_CANDIDATO						numeric(10)
		,COD_SOGGETTO					varchar(10) NULL
		,FLG_INVIATO_CSOD				char(1) NULL
		,DT_INIZIO_ITER					datetime NULL
		,DT_MOD_CAND					datetime NULL
		,FLG_INVIATO_FB					char(1) NULL
		,UserID							varchar(100) NULL
		,UserName						varchar(50) NULL
		,Active							varchar(20) NULL
		,Absent							varchar(10) NULL
		,Reconcile						varchar(10) NULL
		,Prefix							varchar(100) NULL
		,FirstName						varchar(50) NULL
		,MiddleName						varchar(50) NULL
		,LastName						varchar(50) NULL
		,Suffix							varchar(100) NULL
		,Email							varchar(100) NULL
		,Phone							varchar(50) NULL
		,Fax							varchar(50) NULL
		,CountryCode					varchar(10) NULL
		,Line1							varchar(100) NULL
		,Line2							varchar(100) NULL
		,City							varchar(100) NULL
		,State_Province					varchar(100) NULL
		,PostalCode						varchar(5) NULL
		,DivisionID						varchar(50) NULL
		,LocationID						varchar(50) NULL
		,PositionID						varchar(50) NULL
		,CostCenterID					varchar(50) NULL
		,GradeID						varchar(50) NULL
		,LastHireDate					varchar(10) NULL
		,OriginalHireDate				varchar(10) NULL
		,RequiredApprovals				varchar(100) NULL
		,ApproverID						varchar(50) NULL
		,ManagerID						varchar(50) NULL
		,Gender							varchar(10) NULL
		,Ethnicity						varchar(100) NULL
		,ClosureDate					varchar(10) NULL
		,Society						varchar(100) NULL
		,TaxCode						varchar(16) NULL
		,TimeZone						varchar(10) NULL
		,Language						varchar(10) NULL
		,TypeContract					varchar(100) NULL
		,Age							varchar(5) NULL
		,BirthDate						varchar(10) NULL
		,ContrattoMandato				varchar(50) NULL
		,ProfiloCandidato				varchar(50) NULL
		,FamigliaProfessionale			varchar(50) NULL
		,SottoFamigliaProfessionale		varchar(50) NULL
		,Qualifica						varchar(50) NULL
		,StatusAssenza					varchar(70) NULL
		,DataInizioAssenza				varchar(10) NULL
		,DataFineAssenza				varchar(10) NULL
		,ConsorzioID					varchar(15) NULL
		,UserIns						varchar(20) NULL
	)


	insert into #candidati_out (
		N_CANDIDATO
		,COD_SOGGETTO
		,FLG_INVIATO_CSOD
		,DT_INIZIO_ITER
		,DT_MOD_CAND
		,FLG_INVIATO_FB
		,UserID
		,UserName
		,Active
		,Absent
		,Reconcile
		,Prefix
		,FirstName
		,MiddleName
		,LastName
		,Suffix
		,Email
		,Phone
		,Fax
		,CountryCode
		,Line1
		,Line2
		,City
		,State_Province
		,PostalCode
		,DivisionID
		,LocationID
		,PositionID
		,CostCenterID
		,GradeID
		,LastHireDate
		,OriginalHireDate
		,RequiredApprovals
		,ApproverID
		,ManagerID
		,Gender
		,Ethnicity
		,ClosureDate
		,Society
		,TaxCode
		,TimeZone
		,Language
		,TypeContract
		,Age
		,BirthDate
		,ContrattoMandato
		,ProfiloCandidato
		,FamigliaProfessionale
		,SottoFamigliaProfessionale
		,Qualifica
		,StatusAssenza
		,DataInizioAssenza
		,DataFineAssenza
		,ConsorzioID
		,UserIns
	)
	select cand.N_CANDIDATO
			,cand.COD_SOGGETTO
			,cand.FLG_INVIATO_CSOD
			,cand.DT_INIZIO_ITER
			,cand.DT_MOD_CAND
			,cand.FLG_INVIATO_FB
			,cand.UserID						--UserID
			,cand.UserName						--UserName
			,cand.Active						--Active
			,cand.Absent						--Absent
			,cand.Reconcile						--Reconcile
			,cand.Prefix						--Prefix
			,FirstName							--FirstName
			,cand.MiddleName					--MiddleName
			,cand.LastName						--LastName
			,cand.Suffix						--Suffix
			,cand.Email							--Email
			,cand.Phone							--Phone
			,cand.Fax							--Fax
			,cand.CountryCode					--CountryCode
			,cand.Line1 						--Line1
			,cand.Line2							--Line2
			,cand.City							--City
			,cand.State_Province				--State_Province
			,cand.PostalCode					--PostalCode
			,cand.DivisionID					--DivisionID
			,cand.LocationID					--LocationID
			,cand.PositionID					--PositionID
			,cand.CostCenterID					--CostCenterID
			,cand.GradeID						--GradeID
			,cand.LastHireDate					--LastHireDate
			,cand.OriginalHireDate				--OriginalHireDate
			,cand.RequiredApprovals				--RequiredApprovals
			,cand.ApproverID					--ApproverID
			,cand.ManagerID						--ManagerID
			,cand.Gender						--Gender
			,cand.Ethnicity						--Ethnicity
			,cand.ClosureDate					--ClosureDate, CustomField
			,cand.Society						--Society, CustomField
			,cand.TaxCode						--TaxCode, CustomField
			,cand.TimeZone						--TimeZone
			,cand.Language						--Language
			,cand.TypeContract					--TypeContract, CustomField
			,cand.Age							--Age, CustomField
			,cand.BirthDate						--BirthDate, CustomField
			,cand.ContrattoMandato				--ContrattoMandato, CustomField
			,cand.ProfiloCandidato				--Talent, CustomField
			,cand.FamigliaProfessionale			--FamigliaProfessionale, CustomField
			,cand.SottoFamigliaProfessionale	--SottoFamigliaProfessionale, CustomField
			,cand.Qualifica						--Qualifica, CustomField
			,StatusAssenza						--StatusAssenza, CustomField
			,DataInizioAssenza					--DataInizioAssenza, CustomField
			,DataFineAssenza					--DataFineAssenza, CustomField
			,cand.ConsorzioID					--New UO ID
			,cand.UserIns
	from (
		select acc.N_CANDIDATO
				,aca.COD_SOGGETTO
				,acc.FLG_INVIATO_CSOD
				,iter.DT_INIZIO as DT_INIZIO_ITER
				,acc.DT_MOD as DT_MOD_CAND
				,acc.FLG_INVIATO_FB
				--
				-- Gestione anche dei candidati registrati a partire da recruiting su CSOD
				--
				,case when (isNull(acc.USER_INS, '') = 'CSOD_CANDIDATI')
					then  aca.CSOD_IDUTENTE
					else 'C' + isNull(aca.COD_MEDCAMPUS, replicate('0', 9)) 
				end as UserID
				,right(replicate('0', 9) + 'C' + isNull(aca.COD_MEDCAMPUS, ''), 10) as UserName
				,case when isNull(aapa.ATTIVO_DIMISSIONARIO, 'ATTIVO') = 'ATTIVO' then 'true'
					else 'false'
				end as Active
				,''	as Absent
				,'' as Reconcile
				,'' as Prefix
				,aca.NOME as FirstName
				,'' as MiddleName
				,aca.COGNOME as LastName
				,'' as Suffix
				,case when aca.E_MAIL like '%@%.%'
					then aca.E_MAIL
					else ''
				end as Email
				,aca.CELLULARE as Phone
				,'' as Fax
				,'IT' as CountryCode
				,substring(ltrim(isNull(aca.TOPONIMO_C_TOPONIMO + ' ', '') + isNull(aca.INDIRIZZO + ' ', '') + ' ' + isNull(aca.NUM_CIVICO, '')), 1, 55) as Line1
				,substring(ltrim(isNull(aca.TOPONIMO_C_TOPONIMO + ' ', '') + isNull(aca.INDIRIZZO + ' ', '') + ' ' + isNull(aca.NUM_CIVICO, '')), 56, 55) as Line2
				,aca.COMUNE as City
				,aca.PROVINCIA as State_Province
				,aca.CAP as PostalCode
				,'I' + 'CD_' + isNull(cast(div.DivisionID as varchar), 'NA') AS DivisionID
				,'I0000000000' as LocationID
				,'IP' as PositionID
				,'' as CostCenterID
				,'I00000' as GradeID
				,'' as LastHireDate
				,'' as OriginalHireDate
				,'0' as RequiredApprovals
				,'' as ApproverID
				,spv.COD_RIFERIMENTO as ManagerID
				,case when aca.SESSO = 'M'
						then 'Male'
						else 'Female'
				end as Gender
				,'' as Ethnicity
				,'' as ClosureDate															--CustomField 
				--,'ATTIVO' as ActiveDetail													--CustomField 
				,'' as Society																--CustomField
				,isNull(aca.COD_FISCALE, '') as TaxCode										--CustomField
				,'28' as TimeZone															--CustomField
				,'it-IT' as Language														--CustomField
				,'' as TypeContract															--CustomField
				,'' as Age																	--CustomField
				,'' as BirthDate															--CustomField
				,isNull(acc.COD_STATO_MANDATO, 'MANDATO_DA_EMETTERE') as ContrattoMandato	--CustomField
				,CASE WHEN isNull(iter.NOME_ITER, '') = 'WEB RECRUITING'
					 THEN 'TALENT'
					 ELSE 'NO_TALENT'
				 END AS ProfiloCandidato
				,'' as FamigliaProfessionale
				,'' as SottoFamigliaProfessionale
				,'' as Qualifica
				,'NO' as StatusAssenza
				,'09/01/2017' as DataInizioAssenza											--CustomField, formato mm/dd/yyyy
				,'01/01/2077' as DataFineAssenza											--CustomField, formato mm/dd/yyyy
				,'NO_CONSORZIO' as ConsorzioID												--New UO ID
				,isNull(acc.USER_INS, '') as UserIns
		from ARC_CANDIDATI_CSOD acc
		inner join ARC_CANDIDATO aca on aca.N_CANDIDATO = acc.N_CANDIDATO
		left join ARC_ATTUALE_P_ANAG aapa on aapa.STUD_ID = 'C' + aca.COD_MEDCAMPUS
		left join ARC_RIFERIMENTI_CANDIDATO spv on spv.N_CANDIDATO = aca.N_CANDIDATO and spv.COD_TIPO_RIFER = 'SPV' and spv.FLG_ANNULLATO = 'N'
		left join ARC_ANAG_SOGGETTO aas on aas.COD_SOGGETTO = spv.COD_RIFERIMENTO and aas.FLG_ANNULLATO = 'N'
		left join (
			select amcu.STUD_ID, count(*) as NUM_CERT
			from ARC_MCU_CERTIFICAZIONI_UTENTI amcu
			where amcu.ID_CERTIFICAZIONE in (
				select atv.VAL_OUT 
				from ARC_TRASCODIFICA_VALORI atv
				where atv.COD_DOMINIO = 'CSOD_CERTIFICAZIONI_MANDATO'
			)
			group by amcu.STUD_ID
		) cut on cut.STUD_ID = 'C' + isNull(aca.COD_MEDCAMPUS, '')
		left join (
			select agoc.FOGLIA as N_ANAG_SOGG, aes.COD_ETICHETTA DivisionID 
			from ARC_GERARCHIA_ORIZZONTALE_COMM agoc
			inner join ARC_ETICHETTA_SOGG aes on aes.N_ANAG_SOGG = agoc.DIVISIONAL_RIF 
			where aes.FLG_ANNULLATO = 'N'
			and convert(datetime, convert(varchar, getdate(),112)) between aes.DT_INIZIO_ETICHETTA and aes.DT_FINE_ETICHETTA
		) div on div.N_ANAG_SOGG = aas.N_ANAG_SOGG
		left join ARC_FILIALE_SOGG afs on afs.N_ANAG_SOGG = aas.N_ANAG_SOGG and afs.FLG_ANNULLATO = 'N'
		and convert(varchar(8), getdate(), 112) between afs.DT_INIZIO_VALID and afs.DT_FINE_VALID
		left join (
			select s1.N_RIFERIMENTO, s1.DT_INIZIO, s2.NOME_ITER
			from (
			select ie.N_RIFERIMENTO, max(ile.DT_INIZIO) DT_INIZIO
			from ARC_ITER ai
			inner join ARC_ITER_LEGAME_ENTITA ile on ile.COD_ITER = ai.COD_ITER  --399563
			inner join ARC_ITER_ENTITA ie ON ie.COD_ENTITA = ile.COD_ENTITA and ie.TIPO = ile.TIPO
			where ile.FLG_ANNULLATO = 'N'
			and ie.FLG_ANNULLATO = 'N'
			group by ie.N_RIFERIMENTO
			) s1
			inner join 
			(
			select ie.N_RIFERIMENTO, DT_INIZIO, ai.NOME_ITER
			from ARC_ITER ai
			inner join ARC_ITER_LEGAME_ENTITA ile on ile.COD_ITER = ai.COD_ITER  --399563
			inner join ARC_ITER_ENTITA ie ON ie.COD_ENTITA = ile.COD_ENTITA and ie.TIPO = ile.TIPO
			where ile.FLG_ANNULLATO = 'N'
			and ie.FLG_ANNULLATO = 'N'
			) s2 on s2.N_RIFERIMENTO = s1.N_RIFERIMENTO and s2.DT_INIZIO = s1.DT_INIZIO
		) iter on iter.N_RIFERIMENTO = aca.N_CANDIDATO
		where aca.FLG_ANNULLATO = 'N'
		--
		-- Origine candidato = 'CSOD_CANDIDATI' implica gestione Candidati su CORNERSTONE
		-- Quindi non serve inviare alcuna informazione
		--
		and isNull(aca.ORIGINE_CANDIDATO, '') <> 'CSOD_CANDIDATI'
	) cand


	-- 
	-- Passaggio 3: CANDIDATI che sono diventati FB devono registrare il cambiamento di ID verso CSOD
	--

	set @separator = '|'
	
	--
	-- Inserimento INTESTAZIONI per CHANGE ID
	--
	insert into TMP2..CHANGE_ID_CORNERSTONE (
		CAMPO
		,ORDINE
	)
	values (
		'CurrentID'
		+ @separator + 'NewID'
		,0  --campo ordine
	)

	insert into TMP2..CHANGE_ID_CORNERSTONE (
		CAMPO
		,ORDINE
	)
	select	distinct cao.UserID
			+ @separator + uso.UserID
			,1
	from #user_out uso
	inner join #candidati_out cao ON cao.COD_SOGGETTO = uso.COD_SOGGETTO
	where isNull(cao.FLG_INVIATO_FB, 'N') = 'N'

	update ARC_CANDIDATI_CSOD
		set FLG_INVIATO_FB = 'S'
	from ARC_CANDIDATI_CSOD acc
	inner join #candidati_out cao on cao.N_CANDIDATO = acc.N_CANDIDATO
	inner join #user_out uso ON uso.COD_SOGGETTO = cao.COD_SOGGETTO
	where isNull(cao.FLG_INVIATO_FB, 'N') = 'N'
	
	set @separator = CHAR(9)

	-- 
	-- Passaggio 4: Popolazione della tabella OUT con tutti gli utenti da inviare a CSOD
	--

	--
	-- Inserimento INTESTAZIONI utenti
	--
	insert into TMP2..USER_CORNERSTONE (
		CAMPO
		,ordine
	)
	values (
		'#UserID'
		+ @separator + 'UserName'
		+ @separator + 'Active'
		+ @separator + 'Absent'
		+ @separator + 'Reconcile'
		+ @separator + 'Prefix'
		+ @separator + 'FirstName'
		+ @separator + 'MiddleName'
		+ @separator + 'LastName'
		+ @separator + 'Suffix'
		+ @separator + 'Email'
		+ @separator + 'Phone'
		+ @separator + 'Fax'
		+ @separator + 'CountryCode'
		+ @separator + 'Line1'
		+ @separator + 'Line2'
		+ @separator + 'City'
		+ @separator + 'State_Province'
		+ @separator + 'PostalCode'
		+ @separator + 'DivisionID'
		+ @separator + 'LocationID'
		+ @separator + 'PositionID'
		+ @separator + 'CostCenterID'
		+ @separator + 'GradeID'
		+ @separator + 'LastHireDate'
		+ @separator + 'OriginalHireDate'
		+ @separator + 'RequiredApprovals'
		+ @separator + 'ApproverID'
		+ @separator + 'ManagerID'
		+ @separator + 'Gender'
		+ @separator + 'Ethnicity'
		+ @separator + 'ClosureDate'
		+ @separator + 'Society'
		+ @separator + 'TaxCode'
		+ @separator + 'TimeZone'
		+ @separator + 'Language'
		+ @separator + 'TypeContract'
		+ @separator + 'Age'
		+ @separator + 'BirthDate'
		+ @separator + 'ContrattoMandato'
		+ @separator + 'ProfiloCandidato'
		+ @separator + 'FamigliaProfessionale'
		+ @separator + 'SottoFamigliaProfessionale'
		+ @separator + 'Qualifica'
		+ @separator + 'StatusAssenza'
		+ @separator + 'DataInizioAssenza'
		+ @separator + 'DataFineAssenza'
		+ @separator + 'ConsorzioID'
		,0  --campo ordine
	)
	
	
	--
	-- Inserimento DATI utenti
	--
	insert into TMP2..USER_CORNERSTONE (
		CAMPO
		,ordine
	)
	select
		uso.UserID
		+ @separator + uso.UserName
		+ @separator + uso.Active
		+ @separator + uso.Absent
		+ @separator + uso.Reconcile
		+ @separator + uso.Prefix
		+ @separator + uso.FirstName
		+ @separator + uso.MiddleName
		+ @separator + uso.LastName
		+ @separator + uso.Suffix
		+ @separator + uso.Email
		+ @separator + uso.Phone
		+ @separator + uso.Fax
		+ @separator + uso.CountryCode
		+ @separator + uso.Line1
		+ @separator + uso.Line2
		+ @separator + uso.City
		+ @separator + uso.State_Province
		+ @separator + uso.PostalCode
		+ @separator + uso.DivisionID
		+ @separator + uso.LocationID
		+ @separator + uso.PositionID
		+ @separator + uso.CostCenterID
		+ @separator + uso.GradeID
		+ @separator + uso.LastHireDate
		+ @separator + uso.OriginalHireDate
		+ @separator + uso.RequiredApprovals
		+ @separator + uso.ApproverID
		+ @separator + uso.ManagerID
		+ @separator + uso.Gender
		+ @separator + uso.Ethnicity
		+ @separator + uso.ClosureDate
		+ @separator + uso.Society
		+ @separator + uso.TaxCode
		+ @separator + uso.TimeZone
		+ @separator + uso.Language
		+ @separator + uso.TypeContract
		+ @separator + uso.Age
		+ @separator + uso.BirthDate
		+ @separator + uso.ContrattoMandato
		+ @separator + uso.ProfiloCandidato
		+ @separator + uso.FamigliaProfessionale
		+ @separator + uso.SottoFamigliaProfessionale
		+ @separator + uso.Qualifica
		+ @separator + uso.StatusAssenza
		+ @separator + uso.DataInizioAssenza
		+ @separator + uso.DataFineAssenza
		+ @separator + uso.ConsorzioID
		,1  --campo ordine
	from #user_out uso
	
	
	-- 
	-- Passaggio 5: Popolazione della tabella OUT con tutti i CANDIDATI da inviare a CSOD
	-- e che non sono ancora diventati dei Family Banker
	--

	--
	-- Inserimento DATI CANDIDATI non inseriti da utente CASO_CANDIDATI
	--
	insert into TMP2..USER_CORNERSTONE (
		CAMPO
		,ordine
	)
	select
		UserID
		+ @separator + cao.UserName
		+ @separator + cao.Active
		+ @separator + cao.Absent
		+ @separator + cao.Reconcile
		+ @separator + cao.Prefix
		+ @separator + cao.FirstName
		+ @separator + cao.MiddleName
		+ @separator + cao.LastName
		+ @separator + cao.Suffix
		+ @separator + cao.Email
		+ @separator + cao.Phone
		+ @separator + cao.Fax
		+ @separator + cao.CountryCode
		+ @separator + cao.Line1
		+ @separator + cao.Line2
		+ @separator + cao.City
		+ @separator + cao.State_Province
		+ @separator + cao.PostalCode
		+ @separator + cao.DivisionID
		+ @separator + cao.LocationID
		+ @separator + cao.PositionID
		+ @separator + cao.CostCenterID
		+ @separator + cao.GradeID
		+ @separator + cao.LastHireDate
		+ @separator + cao.OriginalHireDate
		+ @separator + cao.RequiredApprovals
		+ @separator + cao.ApproverID
		+ @separator + cao.ManagerID
		+ @separator + cao.Gender
		+ @separator + cao.Ethnicity
		+ @separator + cao.ClosureDate
		+ @separator + cao.Society
		+ @separator + cao.TaxCode
		+ @separator + cao.TimeZone
		+ @separator + cao.Language
		+ @separator + cao.TypeContract
		+ @separator + cao.Age
		+ @separator + cao.BirthDate
		+ @separator + cao.ContrattoMandato
		+ @separator + cao.ProfiloCandidato
		+ @separator + cao.FamigliaProfessionale
		+ @separator + cao.SottoFamigliaProfessionale
		+ @separator + cao.Qualifica
		+ @separator + cao.StatusAssenza
		+ @separator + cao.DataInizioAssenza
		+ @separator + cao.DataFineAssenza
		+ @separator + cao.ConsorzioID
		,1  --campo ordine
	from #candidati_out cao
	where ((cao.FLG_INVIATO_CSOD = 'N')
	or	(isNull(cao.DT_INIZIO_ITER, cao.DT_MOD_CAND) > cao.DT_MOD_CAND))
	and cao.UserID not in (
		select	cnd.UserID
		from #user_out uso
		inner join #candidati_out cnd ON cnd.COD_SOGGETTO = uso.COD_SOGGETTO
	)
	and isNull(cao.UserIns, '') <> 'CSOD_CANDIDATI'

	--
	-- invio a CSOD tutti i candidati che:
	--    - non sono già stati inviati o hanno avuto modifiche dopo l'invio
	--    - non sono diventati FB
	--	  - non sono stati inseriti dall'utente CSOD_CANDIDATI, ovvero con recruiting su CSOD
	--
	
	update ARC_CANDIDATI_CSOD
	set FLG_INVIATO_CSOD = 'S'
	from ARC_CANDIDATI_CSOD acc
	inner join ARC_CANDIDATO aca on aca.N_CANDIDATO = acc.N_CANDIDATO
	inner join #candidati_out cao on cao.N_CANDIDATO = acc.N_CANDIDATO
	where ((cao.FLG_INVIATO_CSOD = 'N')
	or	(isNull(cao.DT_INIZIO_ITER, cao.DT_MOD_CAND) > cao.DT_MOD_CAND))
	and cao.UserID not in (
		select	cnd.UserID
		from #user_out uso
		inner join #candidati_out cnd ON cnd.COD_SOGGETTO = uso.COD_SOGGETTO
	)
	and isNull(cao.UserIns, '') <> 'CSOD_CANDIDATI'

	
end

go

IF OBJECT_ID('sp_CSOD_EstrazioneUser')	IS NOT NULL
	PRINT '<<< CREATED PROCEDURE dbo.sp_CSOD_EstrazioneUser >>>'
ELSE
	PRINT '<<< FAILED CREATING PROCEDURE dbo.sp_CSOD_EstrazioneUser >>>'
go
 
