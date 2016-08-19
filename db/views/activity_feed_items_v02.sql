SELECT
activity_logs.id AS searchable_id,
'ActivityLog' AS searchable_type,
participations.challenge_id,
activity_logs.user_id as user_id,
activity_logs.created_at as created_at
FROM activity_logs
INNER JOIN participations ON participations.id = participation_id

UNION

SELECT
activity_log_comments.id AS searchable_id,
'ActivityLog::Comment' AS searchable_type,
participations.challenge_id,
activity_log_comments.user_id as user_id,
activity_log_comments.created_at as created_at
FROM activity_log_comments
INNER JOIN activity_logs ON activity_logs.id = activity_log_comments.activity_log_id
INNER JOIN participations ON participations.id = participation_id

UNION

SELECT
participations.id AS searchable_id,
'Participation' AS searchable_type,
participations.challenge_id as challenge_id,
participations.user_id as user_id,
participations.created_at as created_at
FROM participations

