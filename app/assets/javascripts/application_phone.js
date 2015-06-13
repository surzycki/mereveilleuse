// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/core
//= require jquery-ui/widget
//= require jquery-ui/mouse
//= require jquery-ui/position
//= require jquery.cookie
//= require jquery.touchSwipe
//= require jquery.smoothState
//= require bootstrap-sprockets
//= require typeahead-mobile
//= require typeahead-addresspicker
//= require pubsub

// Fastclick might bork other stuff, so if that is the case disable and see what happens
//= require fastclick 

// shim for phantomjs < 2.0.0 and react (for circleci)
//= require es5-shim                

//= require plugins/page_transitions

//= require helpers
//= require react
//= require react_ujs
//= require_tree ./mixins
//= require_tree ./components


//= require inbox
