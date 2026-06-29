(function () {
  var SOURCE = 'od-flutter-preview';
  var FLUTTER_LOG_RE = /Exception|Error:|Unsupported operation|assertion failed|overflowed|\.dart:\d+|widgets library|Another exception|relevant error-causing/i;
  var exceptionBuffer = [];
  var bufferTimer = null;

  function send(level, message, detail) {
    try {
      parent.postMessage({
        source: SOURCE,
        level: level,
        message: String(message || ''),
        detail: detail || null,
        ts: Date.now(),
      }, '*');
    } catch (e) { /* cross-origin parent may be unavailable */ }
  }

  function flushBuffer(level) {
    if (!exceptionBuffer.length) return;
    var text = exceptionBuffer.join('\n');
    exceptionBuffer = [];
    send(level || 'error', text, null);
  }

  function scheduleFlush() {
    if (bufferTimer) clearTimeout(bufferTimer);
    bufferTimer = setTimeout(function () { flushBuffer('error'); }, 100);
  }

  function maybeBufferLine(line) {
    var trimmed = String(line || '').trim();
    if (!trimmed) {
      if (exceptionBuffer.length) scheduleFlush();
      return false;
    }
    if (/^═+|Exception caught|Another exception was thrown|When the exception was thrown|The relevant error-causing widget|relevant error-causing widget was/i.test(trimmed)) {
      exceptionBuffer.push(trimmed);
      scheduleFlush();
      return true;
    }
    if (exceptionBuffer.length) {
      if (/^dart-sdk\/|^package:|^lib\/|at Object\.|^#\d+ |^\.{3}     Normal element|^\.{3}     /i.test(trimmed)) {
        exceptionBuffer.push(trimmed);
        scheduleFlush();
        return true;
      }
      flushBuffer('error');
    }
    return false;
  }

  function captureConsoleLine(level, parts) {
    var joined = parts.join(' ');
    if (maybeBufferLine(joined)) return;
    if (FLUTTER_LOG_RE.test(joined)) send(level, joined, null);
  }

  window.addEventListener('error', function (event) {
    var err = event.error;
    var message = event.message || (err && err.message) || 'Script error';
    var stack = err && err.stack ? String(err.stack) : null;
    send('error', message, {
      filename: event.filename,
      lineno: event.lineno,
      colno: event.colno,
      stack: stack,
    });
    if (stack && /\.dart:\d+|package:|Unsupported operation/i.test(stack)) {
      send('error', stack, { kind: 'stack' });
    }
  });
  window.addEventListener('unhandledrejection', function (event) {
    var reason = event.reason;
    var message = reason && reason.message ? reason.message : String(reason);
    send('error', 'Unhandled promise rejection: ' + message, {
      stack: reason && reason.stack ? String(reason.stack) : null,
    });
  });
  var origError = console.error.bind(console);
  console.error = function () {
    var parts = [];
    for (var i = 0; i < arguments.length; i += 1) parts.push(String(arguments[i]));
    captureConsoleLine('error', parts);
    origError.apply(console, arguments);
  };
  var origWarn = console.warn.bind(console);
  console.warn = function () {
    var parts = [];
    for (var i = 0; i < arguments.length; i += 1) parts.push(String(arguments[i]));
    var joined = parts.join(' ');
    if (!maybeBufferLine(joined) && /error|exception|overflow|failed|unable to load asset/i.test(joined)) {
      send('warn', joined, null);
    }
    origWarn.apply(console, arguments);
  };
  var origLog = console.log.bind(console);
  console.log = function () {
    var parts = [];
    for (var i = 0; i < arguments.length; i += 1) parts.push(String(arguments[i]));
    captureConsoleLine('log', parts);
    origLog.apply(console, arguments);
  };
  send('info', 'Open Design preview bridge ready', null);
})();

