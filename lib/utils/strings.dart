
const welcome = "Welcome Back";
const kDefaultError = 'Something went wrong. Please try again.';

bool isEmpty(String? s )=> s==null || s== "null" || s.trim().isEmpty;
bool isNotEmpty(String? s )=> s !=null && s != "null" && s.trim().isNotEmpty;

String formatError(String s )=> s.replaceAll("Exception:", "");

/// Returns [msg] if non-empty, otherwise a safe fallback the user can read.
String extractError(String? msg) =>
    msg != null && msg.trim().isNotEmpty ? msg.trim() : kDefaultError;