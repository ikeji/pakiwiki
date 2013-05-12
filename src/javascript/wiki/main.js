goog.provide('w.main');
goog.require('w.mobile');


/**
 * Entry point.
 */
w.main = function() {
  w.mobile();
};
goog.exportSymbol('w', w.main);
