---
title: "Introduction"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 0
showChildrenInMenu : true
nav_menu: "Concepts and Design"
type: concepts
---


## Introduction


What is CI CD ?

* CI CD has a scope : a set of Business Processes. Those Business Processes are specific to the IT industry, in the field of software management and software production.
* And in that scope, CI CD is also aset of engineering methodlogies, today associated to what is called devops. There is no devops without CICD.


The General concept of the Gravitee.io CI / CD System, is simple : Any CI CD Business Process, can be realized with a set of properly orchestrated Pipelines.

And the high level design the Gravitee.io CI / CD System consists of:
* An Orchestrator, able to orchestrate the execution of any set of Pipelines, so that they globally realize any Business Process.
* To work, the CI CD System uses:
  * A "Git service provider", where it finds all the git repo versioning the source code of the components of the software product.
  * An external service, which is able to run any Pipeline operations, through a REST API. We will call this the Pipeline service provider.

The Orchestrator orchestrates Pipeline executions, a bit like the GNU/Linux OS schedules OS Processes: It knows when to launch a pipeline, what data to feed it with, and retrieves the output data.


<!-- To complete (in the [layouts/general-design/list.html]) -->
