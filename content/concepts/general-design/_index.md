---
title: "General Design"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 0
showChildrenInMenu : true
nav_menu: "Concepts and Design"
type: general-design
---


## General Design of the Gravitee CICD

As mentioned in the introduction, The Orchestrator orchestrates Pipeline executions, a bit like the GNU/Linux OS schedules OS Processes: It knows when to launch a pipeline, what data to feed it with as input, and retrieves the output data.

The GNU/Linux OS schedules process, based on refined algotrithm and execution context data.

The Gravitee CICD Orchestrator orchestrates CICD business processes, based on a JSON file.

For example, it uses the well known `release.json` to run the process of releasing the Gravitee APIM software.




<!-- To complete (in the [layouts/general-design/list.html]) -->
