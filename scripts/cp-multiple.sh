#!/bin/bash

for layoutfile in "$@"
do
    echo "moving $layoutfile "
    mv $layoutfile "block.block.cas_base_$(echo $layoutfile | cut -d'.' -f3 | cut -d'_' -f3- ).yml"
done

