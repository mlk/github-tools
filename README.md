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

Unprotected
-----------

Returns all the repositories in an organisation where the given branch is unprotected.

```
./unprotected.sh
Returns all the repositories in an organisation where the given branch is unprotected.
Example: ./unprotected.sh -o myorg 
 
-h Show help
-o <org name>         The organisation to update; required
-b <branch name>      The branch to check; defaults to master

```

My PRs
------
Shows the current users awaiting PRs.

Requires:

* [hub](https://hub.github.com)
* [jq](https://stedolan.github.io/jq/)
* [csvkit](https://github.com/wireservice/csvkit)

```
./my-prs.sh
Shows all PRs currently assigned to you.
Example: ./my-prs.sh
 
-h Show help
-a Shows authored PRs instead of PRs awaiting review
```
