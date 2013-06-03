# Foreman

This is CERN's foreman fork. Basically this includes some of the patches that are submitted to theforeman/foreman until they get merged in, plus some (very few) patches that are only relevant to CERN.

Config files are managed via puppet, so make sure to run puppet after you pull from this repository.

**Basic steps (given a puppet managed foreman node):**

  *   Clone this repository
  *   rvm default 1.9.2
  *   bundle install --no-deployment
  *   bundle install --deployment
  *   service httpd install
  *  rvm system do puppet agent -t -v

  Then check /var/log/httpd/error_log and /var/log/foreman/production.log to make sure everything went fine.
  Normally you should not need to run these commands manually since puppet will do it for you.

## Merge procedure

  * Switch to branch preproduction
  * Add remote theforeman/foreman (upstream)
* git merge upstream/develop
* git mergetool
* git commit
* git push origin preproduction


Most likely you'll get conflicts, fix them keeping in mind you want to keep the CERN specific code.

Thoroughly test it. If it works properly, then

* git checkout production
* git merge origin/preproduction
* Fix conflicts, hopefully there will be none if you did the preproduction/develop merge correctly and you found no issues
* git push origin production


See http://theforeman.org for additional information.

Copyright (c) 2009-2013 Ohad Levy and Paul Kelly

This program and entire repository is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

