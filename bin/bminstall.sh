#!/bin/bash
#
# JBoss, Home of Professional Open Source
# Copyright 2010-11, Red Hat and individual contributors
# by the @authors tag. See the copyright.txt in the distribution for a
# full listing of individual contributors.
#
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of
# the License, or (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
# You should have received a copy of the GNU Lesser General Public
# License along with this software; if not, write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301 USA, or see the FSF site: http://www.fsf.org.
#
# @authors Andrew Dinn
#
# shell script which can be used to install the Byteman agent into
# a JVM which was started without the agent. This provides an
# alternative to using the -javaagent java command line flag
#
# usage: bminstall [-p port] [-h host] [-b] [-Dname[=value]]* pid
#   pid is the process id of the target JVM
#   -h host selects the host name or address the agent listener binds to
#   -p port selects the port the agent listener binds to
#   -b adds the byteman jar to the bootstrap classpath
#   -Dname=value can be used to set system properties whose name starts with "org.jboss.byteman."
#   expects to find a byteman agent jar in BYTEMAN_HOME
#
# use BYTEMAN_HOME to locate installed byteman release
if [ -z "$BYTEMAN_HOME" ]; then
# use the root of the path to this file to locate the byteman jar
    BYTEMAN_HOME=${0%*/bin/bminstall.sh}
# allow for rename to plain bminstall
    if [ "$BYTEMAN_HOME" == "$0" ]; then
	BYTEMAN_HOME=${0%*/bin/bminstall}
    fi
    if [ "$BYTEMAN_HOME" == "$0" ]; then
	echo "Unable to find byteman home"
	exit
    fi
fi

# check that we can find  the byteman jar via BYTEMAN_HOME

# the Install class is in the byteman-install jar
if [ -r ${BYTEMAN_HOME}/lib/byteman.jar ]; then
    BYTEMAN_JAR=${BYTEMAN_HOME}/lib/byteman.jar
else
    echo "Cannot locate byteman jar"
    exit
fi
# the Install class is in the byteman-install jar
if [ -r ${BYTEMAN_HOME}/lib/byteman-install.jar ]; then
    BYTEMAN_INSTALL_JAR=${BYTEMAN_HOME}/lib/byteman-install.jar
else
    echo "Cannot locate byteman install jar"
    exit
fi
# we also need a tools jar from JAVA_HOME
if [ -z "$JAVA_HOME" ]; then
     echo "please set JAVA_HOME"
     exit
fi
if [ -r ${JAVA_HOME}/lib/tools.jar ]; then
    TOOLS_JAR=${JAVA_HOME}/lib/tools.jar
else
    echo "Cannot locate byteman install jar"
    exit
fi
# allow for extra java opts via setting BYTEMAN_JAVA_OPTS
# attach class will validate arguments

java ${BYTEMAN_JAVA_OPTS} -classpath ${BYTEMAN_INSTALL_JAR}:${TOOLS_JAR} org.jboss.byteman.agent.install.Install $*
