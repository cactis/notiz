/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.editorConfig = function(config){
	// Define changes to default configuration here. For example:
  config.language = 'zh';
  //	config.uiColor = '#AADC6E';
  //config.toolbar : 'Basic',
  //  uiColor : '#9AB8F3'
  config.toolbarCanCollapse = true;
  config.toolbar_Full = [
    [ 'Source', '-','Save', '-', 'DocProps','Preview','Print','-','Templates' ],
    [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ],
    [ 'Find','Replace','-','SelectAll','-' ],
    [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ],
    [ 'NumberedList','BulletedList','-','Outdent','Indent'],
    ['Blockquote','CreateDiv'], ['JustifyLeft','JustifyCenter', 'JustifyRight','JustifyBlock'],['BidiLtr','BidiRtl' ],
    [ 'Link','Unlink','Anchor' ],
    [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak' ],
    [ 'Styles','Format','Font','FontSize' ],
    [ 'TextColor','BGColor' ],
    [ 'Maximize'],['ShowBlocks','-','About' ]
  ];
};

//CKEDITOR.editorConfig = function(config){
//    config.uiColor = '#C2CEEA';
//    config.toolbar_Basic = [
//      ['Source', '-', 'Save', '-', 'Bold', 'Italic', 'Underline', 'Strike', 'RemoveFormat', '-', 'Image', 'Flash', 'Link', 'Unlink', '-', 'NumberedList', 'BulletedList'], ['Maximize'], ['About']];
//    config.toolbar_Full = [['Source', '-', 'Save','-', 'Preview', '-', 'Templates'], ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Print'], ['Undo', 'Redo', '-', 'Find', 'Replace', '-', 'SelectAll', 'RemoveFormat'], ['Maximize', 'ShowBlocks'], ['Link', 'Unlink', 'Anchor'], ['Image', 'Flash', 'Table', 'Form'], ['HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak'], ['Bold', 'Italic', 'Underline', 'Strike', '-', 'Subscript', 'Superscript','-', 'NumberedList', 'BulletedList', 'Outdent', 'Indent', 'Blockquote'],['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'], ['Styles', 'Format', 'Font', 'FontSize'], ['TextColor', 'BGColor'], ['About']];
//}

