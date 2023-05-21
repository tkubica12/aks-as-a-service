## Policies

10 security policies are implemented
- Policies are applied in default configuration to all applications
- On per-application basis exclusions can be managed:
  - Whole policy can be excluded from application
  - Where possible more granular exclusions are available based on image name/path
- Allowed image policy is applied by default to all applications
- On per-application basis regex list can be overridden
  - Application can get less restrictive by opening access to more paths without allowing the same for other applications
  - Override list replaces default completely so application can get more restrictive eg. by being specific to level of registry/repo/image:tag