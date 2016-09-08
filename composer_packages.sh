#!/usr/bin/env bash
   
set -e 

composer require "phalcon/devtools" -d /usr/local/bin/
ln -sf /usr/local/bin/vendor/phalcon/devtools/phalcon.php /usr/bin/phalcon
