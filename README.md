# Myria Website

Website for the UW myria project.

See the site in action at [myria.cs.washington.edu](http://myria.cs.washington.edu/).

## How to make changes

**Warning: do not edit the subfolders in docs/.../** <br/>
`docs/index.md` is okay to edit.

* clone this repo
* install [jekyll](http://jekyllrb.com/).
  Don't forget to install a javascript engine, e.g. `sudo apt-get install nodejs`.
* run jekyll `jekyll serve --watch --baseurl ''` to see your changes on your local machine
* submit changes to go on the Myria website
  by submitting a pull request by committing and pushing your changes 

If jekyll throws a version error, you may need to `gem install json` before serving.


### Updating subfolders of `docs/`

These subfolders are copied from the docs inside the Myria stack's repos.
You can update them by running the script: `./subtree-pull.sh`.
Please make sure you have no uncommitted changes to files before runnning the script.

To add docs from a new repository, please follow the format inside `subtree.config`.

### Add a project


To add a project, add a new file in [projects/_posts](https://github.com/uwescience/myria-website/tree/gh-pages/projects/_posts) similar to the exisiting ones. Your project will be automatically added to the main projects page. 
