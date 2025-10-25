#!/bin/sh

echo on > /sys/kernel/debug/dri/1/DP-2/force
echo 1  > /sys/kernel/debug/dri/1/DP-2/trigger_hotplug
