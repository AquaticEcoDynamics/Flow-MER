#!/bin/bash

executable="/Users/Casper/AED_Tools_Dev/binaries/tfv_aed_20160920_u_sd"

cd CEW_2015_2016_noCEW_v1/Input

$executable lower_lakes.fvc

cd ../../CEW_2015_2016_noALL_v1/Input

$executable lower_lakes.fvc

cd ../../CEW_2015_2016_Obs_v1_rerun/Input

$executable lower_lakes.fvc



