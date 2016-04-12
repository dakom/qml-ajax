# Qml-Ajax
This is a fully-functioning demo project showing how to do ajax via qml, and also some minimal boilerplate for a larger project setup

It uses the "echo" service at jsfiddle.net, though that can be configured in config.js

# Why and How?
The various examples I found online didn't do things in a truly production-ready way, and coherent community support on this as a complete solution is kinda hard to come by- so I decided to put something together and keep it here. The code isn't commented (yet?) but it does answer the following gotchas which bit me at first (and are basic necessities for a production-ready larger services-based app):

1. How to do threaded requests that don't block the UI (WorkerScript)
2. How to access global vars from the WorkerScript js (don't - make calls from the main thread side and pass the data around)
3. How to bubble up signals from anywhere to anywhere (don't - use callbacks in a common js library)
4. How to handle multiple ajax requests (keep a map of existing requests, pass the id around for abort() etc.)
5. How to organize views and helper qml so they can be both imported and loaded
6. How to deal with requests that are relevant to both the worker thread and the main thread (maintain private info on each, referenced by the same id, and pass messages to trigger actions like delete/open/etc.)

There's also some extra stuff like dealing with a "close" action in the middle of a request (pass a deleteService() callback to statusCallbackAfterClose()), knowing when the qml has loaded not just from its own perspective but from the loader (evidently those are different), and a couple other goodies

The basic idea with the files are:

* api.js is a global js library (I use module syntax just to keep it neat). Among other things it deals with:
 * locale/status lookups
 * main thread service map
 * callbacks for cross-boundry "signals" (i.e. to display status window on main.qml from some deeply nested qml, in this case basically start)
 * common library for internal js calls
* workers.js is a *totally blind* worker js file that maintains its own copy of the xhr map for its own purposes (really just to abort), but basically is just glue to talk between the main thread and the remote server.
* ServiceWorker.qml is the component used from the main thread side to speak to workers.js. Right now it's only to call ajax services, though that could be expanded to other types of workers. It also does sanity checking on the service response and calls the appropriate callbacks (stored in the map on api.js)
* StatusDialog.qml for showing the response and close button. The close button will hideitself but also tell js Main api that it's closed, so js Main api can call the appropriate callback if one has been set
* ColorButton is just eyecandy for making a nicer looking button with gradients
* Start.qml is a main window view. In a larger project there would be many of these which can be swapped via config.Main.loadView()
* main.qml is the main qml... it holds the status window (and can therefore be launched from any view) and any other views

# Caveats

If you got this far, you might notice that there can be multiple requests happening, each with their own callbacks, but the "statusCallbackAfterClose()" callback which is triggered by the status window being closed will only call the most recent assignment. This is intentional, since it corresponds to the user experience of closing whatever the most recent request is. If that doesn't fit your use case, maybe consider checking it against a list of ID's on the status window itself since it's a single component sitting on main.  

Anyway, enjoy!
-David
