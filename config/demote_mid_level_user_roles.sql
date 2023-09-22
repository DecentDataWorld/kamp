--make KAMP moderators => members
---- on staging DB this updates 1 record
UPDATE users_roles 
SET role_id = (
    SELECT id 
    FROM roles 
    WHERE name = 'member'
) 
WHERE role_id = (
    SELECT id 
    FROM roles 
    WHERE name = 'moderator'
);

-- make ORG editors => members
---- on staging DB this updates 12 records
UPDATE users_organizations
SET role = 'member'
WHERE role = 'editor';