create or replace table fact.lok_sabha_fact as 
with attendence_data as 
  (select lok_sabha
    , session
    ,dateOfAttendance
    ,mpsno
    ,division
    ,memberName
    ,attendanceStatus
    ,case when attendanceStatus='NS' then 'Member did not sign'
      when attendanceStatus='NS@' then 'Member present but forgot to sign'
      when attendanceStatus='NR' then 'Not Required'
      when attendanceStatus='S#' then 'Signed both Register & Mobile'
      when attendanceStatus='S*' then 'Signed through Mobile'
      when attendanceStatus='S' then 'Member signed'
      end as attendenceCtg
    
    ,case when attendanceStatus in ('NS@','S#','S*','S') then True
       when attendanceStatus in ('NS') then False end as isPresent

  from member_attendence)

,session_dates as 
  (select * 
  from loksabha_session)

,mp_metadata as 
  (select * 
  from member_metadata)

select attendence_data.*
  -- ,mpLastFirstName
  ,mp_metadata.status
  ,mp_metadata.noOfTerms
  ,mp_metadata.stateName
  ,partySname
  ,profession
  ,profession2
  ,partyFname
  ,gender
  ,constName
  ,qualification
  ,maritalStatus
  ,age
  ,dob
  ,date_diff(dateOfAttendance,dob,day)/365 as calculatedAge
from attendence_data
left join mp_metadata on mp_metadata.mpsno=cast(attendence_data.mpsno as Int)