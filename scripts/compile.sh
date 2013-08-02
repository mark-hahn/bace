#!/bin/sh

if [ -d  src ]
	then
		coffee -mo lib src/client/*.coffee
		coffee -mo lib src/server/*.coffee
fi