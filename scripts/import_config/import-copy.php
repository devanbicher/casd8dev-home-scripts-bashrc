<?php

// Import arbitrary config from a variable.
// Assumes $data has the data you want to import for this config.
$config = \Drupal::service('config.factory')->getEditable('filter.format.basic_html');
$config->setData($data)->save();

// Or, re-import the default config for a module or profile, etc.
\Drupal::service('config.installer')->installDefaultConfig('module', 'my_custom_module');

// Or, import YAML config from an arbitrary file.
$config_path = drupal_get_path('module', 'my_custom_module') . '/config/install';
$source = new FileStorage($config_path);
$config_storage = \Drupal::service('config.storage');
$config_storage->write('filter.format.basic_html', $source->read('filter.format.basic_html'));
