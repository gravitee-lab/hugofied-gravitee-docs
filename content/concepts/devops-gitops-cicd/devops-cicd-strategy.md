---
title: "Infrastructure design: Testing strategies"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "Standard Operations"
menu: devops_gitops_cicd
menu_index: 21
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: devops-gitops-cicd
---

## Infrastructure design and Testing strategies

So imagine no gravitee software source code happened, and what we want is just about  testing a new infrastructure architecture.

How good a fixed, given version of Gravitee, will be, in a given infrastructure architecture. To begin with, here, defining "How good", is a work in itself, it is bout the part of Quality where we define "metrics".


This kind of work is not the purpose of the nightly deployment. The purpose of the nightly deployment is to test the gravitee software, based on N well designed, tested, and approved infrastructure architectures. Desiging, testing, and approving those infrastructure design ahs to be donne in a a different workflow :
*  When we work on infrastructure, we will change version of the infrastructure (which is versioned because we are gitops minded, and because we are full Infastructure as code)
* When we deploy the nightly, we change the version of the software
* And we will never, ever, perform tests where we change version of both the software, and of its infrastrucure: It is a bi tlike when you have to solve an equation with 2+ variables. Or study a 2+ parameter funtion. You fix the value of one parameter, and continuously change the value of the other, to "find a special point of the funtion". The optimization point.

So basically, we do not use the nightly to think about / work on infrastructure, we use the nightly to test the software. The nightly then deploys to N deployment targets, one for each infrastructure design, all provisioned independently. Typically Dev, Integration, Staging, and Production. Today, the devops work on pulumi is designing a first architecture. This first certainly won't be production ready, but we do  know that we want a first thing with this deployement : we want to make sure that, "whan all the work is bundled together, then all unit and integration tests pas". SO I willsay that this first deployement target is meant to be designed as an "Integration Tests environment".

All in all, this means that:
* we will work on infrastructure (so on snapshots versions of the infratructure), using RELASES, not snapshots, of Gravitee: That way when we test here, and something ugly happens, we know that it is an infrastructure issue, not a software issue (because it is rock solid).
* And we will work on software (so on snapshots versions of the software), using RELEASES, of the infrastructure, not snapshots: That way when we test here, and something ugly happens, we know that it is a software issue, not infrastructure issue (because it is rock solid).

Finally, In the case of cockpit, before any release of cockpit has happened, to initialize this cylce, here is how we do : we work until a helm cahrt successfully deploys Cockpit. When we do, then the devops will note down, the exact version of cockpit, on the master branch, which was used to successfully deploys. This version is a hash commit, and must be found as label metadata in the Docker image used in the helm chart.
Now, using this reference Cockpit version, the Devops team will design the infrastructure until we get a first decent version of an integration tests deployement target.

In a word, init is about finding a first Cockpit `master` commit, on which to start.
Et voilà.
