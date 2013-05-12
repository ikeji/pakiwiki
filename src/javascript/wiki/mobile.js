goog.provide('w.mobile');

goog.require('goog.dom');
goog.require('goog.dom.classlist');
goog.require('goog.events');
goog.require('goog.events.EventType');


/**
 * Initialize mobile stuff.
 */
w.mobile = function() {
  var menulink = goog.dom.getElementByClass('menu-link');
  var editlink = goog.dom.getElementByClass('edit-link');
  var backlink = goog.dom.getElementByClass('back-link');
  var menu = goog.dom.getElementByClass('menu');
  var edit = goog.dom.getElementByClass('edit');
  var article = goog.dom.getElementByClass('main');
  console.log(menulink);
  goog.events.listen(
      menulink,
      goog.events.EventType.CLICK,
      function(e) {
        goog.dom.classlist.add(menulink, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.add(editlink, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.remove(backlink, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.remove(menu, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.add(edit, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.add(article, w.mobile.HIDE_CLASS_);
      });
  goog.events.listen(
      editlink,
      goog.events.EventType.CLICK,
      function(e) {
        goog.dom.classlist.add(menulink, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.add(editlink, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.remove(backlink, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.add(menu, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.remove(edit, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.add(article, w.mobile.HIDE_CLASS_);
      });
  goog.events.listen(
      backlink,
      goog.events.EventType.CLICK,
      function(e) {
        goog.dom.classlist.remove(menulink, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.remove(editlink, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.add(backlink, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.add(menu, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.add(edit, w.mobile.HIDE_CLASS_);
        goog.dom.classlist.remove(article, w.mobile.HIDE_CLASS_);
      });
};


/**
 * A dom class name for hide the element in mobile mode.
 * @const
 * @private
 */
w.mobile.HIDE_CLASS_ = 'mobhide';
