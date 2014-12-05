Whetstone
=========

Getting Started
---------------

This repository comes equipped with a self-setup script!

    % ./bin/setup

After setting up, you can run the application using foreman:

    % foreman start

Make sure you edit .env to configure OAuth.

Since Whetstone OAuths against Upcase, you'll need to have the Upcase app running
to log in to Whetstone. Additionally, if you clear out your Upcase database,
Whetstone's OAuth application will be lost, and you'll need to regenerate it
and update .env with the new keys.

Deploying
---------

We're using [CircleCI] to automatically deploy to staging once the tests pass.
Once your branch is merged into master, CircleCI will run the tests and then
deploy to staging.

After acceptance is performed on staging, deploy to production as usual.

[CircleCI]: https://circleci.com/gh/thoughtbot/whetstone

Guidelines
----------

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
