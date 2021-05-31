#!/bin/bash

helm3 install -f Guestbook/values.yaml guestbook
helm3 install -f Redis/values.yaml redis