#!/bin/bash

helm3 install -f Guestbook/Config/values.yaml guestbook
helm3 install -f Redis/Config/values.yaml redis
