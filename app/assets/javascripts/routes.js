(function(){

  var defaults = {
    prefix: '',
    format: 'json'
  };
  
  var Utils = {

    serialize: function(obj){
      if (obj === null) {return '';}
      var s = [];
      for (prop in obj){
        s.push(prop + "=" + encodeURIComponent(obj[prop].toString()));
      }
      if (s.length === 0) {
        return '';
      }
      return "?" + s.join('&');
    },

    clean_path: function(path) {
      return path.replace(/\/+/g, "/").replace(/[\)\(]/g, "").replace(/\.$/m, '').replace(/\/$/m, '');
    },

    extract: function(name, options) {
      var o = undefined;
      if (options.hasOwnProperty(name)) {
        o = options[name];
        delete options[name];
      } else if (defaults.hasOwnProperty(name)) {
        o = defaults[name];
      }
      return o;
    },

    extract_format: function(options) {
      var format = options.hasOwnProperty("format") ? options.format : defaults.format;
      delete options.format;
      return format ? "." + format : "";
    },

    extract_anchor: function(options) {
      var anchor = options.hasOwnProperty("anchor") ? options.anchor : null;
      delete options.anchor;
      return anchor ? "#" + anchor : "";
    },

    extract_options: function(number_of_params, args) {
      if (args.length > number_of_params) {
        return typeof(args[args.length-1]) == "object" ?  args.pop() : {};
      } else {
        return {};
      }
    },

    path_identifier: function(object) {
      if (!object) {
        return "";
      }
      if (typeof(object) == "object") {
        return (object.to_param || object.id || object).toString();
      } else {
        return object.toString();
      }
    },

    build_path: function(number_of_params, parts, optional_params, args) {
      args = Array.prototype.slice.call(args);
      var result = Utils.get_prefix();
      var opts = Utils.extract_options(number_of_params, args);
      if (args.length > number_of_params) {
        throw new Error("Too many parameters provided for path");
      }
      var params_count = 0, optional_params_count = 0;
      for (var i=0; i < parts.length; i++) {
        var part = parts[i];
        if (Utils.optional_part(part)) {
          var name = optional_params[optional_params_count];
          optional_params_count++;
          // try and find the option in opts
          var optional = Utils.extract(name, opts);
          if (Utils.specified(optional)) {
            result += part;
            result += Utils.path_identifier(optional);
          }
        } else {
          result += part;
          if (params_count < number_of_params) {
            params_count++;
            var value = args.shift();
            if (Utils.specified(value)) {
              result += Utils.path_identifier(value);
            } else {
              throw new Error("Insufficient parameters to build path");
            }
          }
        }
      }
      var format = Utils.extract_format(opts);
      var anchor = Utils.extract_anchor(opts);
      return Utils.clean_path(result + format + anchor) + Utils.serialize(opts);
    },

    specified: function(value) {
      return !(value === undefined || value === null);
    },

    optional_part: function(part) {
      return part.match(/\(/);
    },

    get_prefix: function(){
      var prefix = defaults.prefix;

      if( prefix !== "" ){
        prefix = prefix.match('\/$') ? prefix : ( prefix + '/');
      }
      
      return prefix;
    }

  };

  window.AppRoutes = {
// trees => /trees(.:format)
  trees_path: function(options) {
  return Utils.build_path(0, ["/trees"], ["format"], arguments)
  },
// new_tree => /trees/new(.:format)
  new_tree_path: function(options) {
  return Utils.build_path(0, ["/trees/new"], ["format"], arguments)
  },
// edit_tree => /trees/:id/edit(.:format)
  edit_tree_path: function(_id, options) {
  return Utils.build_path(1, ["/trees/", "/edit"], ["format"], arguments)
  },
// tree => /trees/:id(.:format)
  tree_path: function(_id, options) {
  return Utils.build_path(1, ["/trees/"], ["format"], arguments)
  },
// posts => /posts(.:format)
  posts_path: function(options) {
  return Utils.build_path(0, ["/posts"], ["format"], arguments)
  },
// new_post => /posts/new(.:format)
  new_post_path: function(options) {
  return Utils.build_path(0, ["/posts/new"], ["format"], arguments)
  },
// edit_post => /posts/:id/edit(.:format)
  edit_post_path: function(_id, options) {
  return Utils.build_path(1, ["/posts/", "/edit"], ["format"], arguments)
  },
// post => /posts/:id(.:format)
  post_path: function(_id, options) {
  return Utils.build_path(1, ["/posts/"], ["format"], arguments)
  },
// notes => /notes(.:format)
  notes_path: function(options) {
  return Utils.build_path(0, ["/notes"], ["format"], arguments)
  },
// new_note => /notes/new(.:format)
  new_note_path: function(options) {
  return Utils.build_path(0, ["/notes/new"], ["format"], arguments)
  },
// edit_note => /notes/:id/edit(.:format)
  edit_note_path: function(_id, options) {
  return Utils.build_path(1, ["/notes/", "/edit"], ["format"], arguments)
  },
// note => /notes/:id(.:format)
  note_path: function(_id, options) {
  return Utils.build_path(1, ["/notes/"], ["format"], arguments)
  },
// tags => /tags(.:format)
  tags_path: function(options) {
  return Utils.build_path(0, ["/tags"], ["format"], arguments)
  },
// new_tag => /tags/new(.:format)
  new_tag_path: function(options) {
  return Utils.build_path(0, ["/tags/new"], ["format"], arguments)
  },
// edit_tag => /tags/:id/edit(.:format)
  edit_tag_path: function(_id, options) {
  return Utils.build_path(1, ["/tags/", "/edit"], ["format"], arguments)
  },
// tag => /tags/:id(.:format)
  tag_path: function(_id, options) {
  return Utils.build_path(1, ["/tags/"], ["format"], arguments)
  },
// new_user_session => /users/sign_in(.:format)
  new_user_session_path: function(options) {
  return Utils.build_path(0, ["/users/sign_in"], ["format"], arguments)
  },
// user_session => /users/sign_in(.:format)
  user_session_path: function(options) {
  return Utils.build_path(0, ["/users/sign_in"], ["format"], arguments)
  },
// destroy_user_session => /users/sign_out(.:format)
  destroy_user_session_path: function(options) {
  return Utils.build_path(0, ["/users/sign_out"], ["format"], arguments)
  },
// user_omniauth_callback => /users/auth/:action/callback(.:format)
  user_omniauth_callback_path: function(_action, options) {
  return Utils.build_path(1, ["/users/auth/", "/callback"], ["format"], arguments)
  },
// user_password => /users/password(.:format)
  user_password_path: function(options) {
  return Utils.build_path(0, ["/users/password"], ["format"], arguments)
  },
// new_user_password => /users/password/new(.:format)
  new_user_password_path: function(options) {
  return Utils.build_path(0, ["/users/password/new"], ["format"], arguments)
  },
// edit_user_password => /users/password/edit(.:format)
  edit_user_password_path: function(options) {
  return Utils.build_path(0, ["/users/password/edit"], ["format"], arguments)
  },
// cancel_user_registration => /users/cancel(.:format)
  cancel_user_registration_path: function(options) {
  return Utils.build_path(0, ["/users/cancel"], ["format"], arguments)
  },
// user_registration => /users(.:format)
  user_registration_path: function(options) {
  return Utils.build_path(0, ["/users"], ["format"], arguments)
  },
// new_user_registration => /users/sign_up(.:format)
  new_user_registration_path: function(options) {
  return Utils.build_path(0, ["/users/sign_up"], ["format"], arguments)
  },
// edit_user_registration => /users/edit(.:format)
  edit_user_registration_path: function(options) {
  return Utils.build_path(0, ["/users/edit"], ["format"], arguments)
  },
// welcome_index => /welcome/index(.:format)
  welcome_index_path: function(options) {
  return Utils.build_path(0, ["/welcome/index"], ["format"], arguments)
  },
// root => /
  root_path: function(options) {
  return Utils.build_path(0, ["/"], [], arguments)
  },
// rails_info_properties => /rails/info/properties(.:format)
  rails_info_properties_path: function(options) {
  return Utils.build_path(0, ["/rails/info/properties"], ["format"], arguments)
  }}
;
  window.AppRoutes.options = defaults;
})();
