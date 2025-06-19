select
	ROW_NUMBER() OVER (ORDER BY student_id, track_name) AS student_track_id,
  	sub.student_id,
  	sub.track_name,
  	sub.date_enrolled,
  	sub.track_completed,
  	sub.days_for_completion,
  	CASE
    	WHEN sub.days_for_completion = 0 THEN 'Same day'
    	WHEN sub.days_for_completion BETWEEN 1 AND 7 THEN '1 to 7 days'
    	WHEN sub.days_for_completion BETWEEN 8 AND 30 THEN '8 to 30 days'
    	WHEN sub.days_for_completion BETWEEN 31 AND 60 THEN '31 to 60 days'
    	WHEN sub.days_for_completion BETWEEN 61 AND 90 THEN '61 to 90 days'
    	WHEN sub.days_for_completion BETWEEN 91 AND 365 THEN '91 to 365 days'
    	WHEN sub.days_for_completion >= 366 THEN '366+ days'
    	ELSE NULL
  	END AS completion_bucket
FROM (
  SELECT
    ctse.student_id,
    cti.track_name,
    ctse.date_enrolled,
    ctse.date_completed,
    CASE
      WHEN ctse.date_completed IS NOT NULL THEN 1
      ELSE 0
    END AS track_completed,
    CASE 
      WHEN ctse.date_completed IS NULL THEN NULL
      ELSE DATEDIFF(ctse.date_completed, ctse.date_enrolled)
    END AS days_for_completion
  FROM career_track_student_enrollments ctse
  JOIN career_track_info cti 
    ON cti.track_id = ctse.track_id
) AS sub;
