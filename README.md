github-tools
============

Some useful scripts for maintaining GitHub organisations.

Update Permissions
------------------
Gives a team the specified permission to every repository in an organisation. 

Requires:

* [hub](https://hub.github.com)
* [jq](https://stedolan.github.io/jq/)

```
Gives the team permission to every GitHub repository.
Example: ./update-permissions.sh -o myorg -t "Team Leads"
 
-h Show help
-o <org name>         The organisation to update; required
-t <team name>        The team in the organisation to give permissions too; required
-p [read|write|admin] The permission to give to the team; defaults to admin
```

