.pragma library

function parseTerminalOutput(input) {
    if (!input) return "";

    // 1. Strip cursor visibility & modes: \x1b[?25l, \x1b[?7l, \x1b[?25h, \x1b[?7h
    var clean = input.replace(/\x1b\[\?[0-9]+[hl]/g, "");

    // 2. Handle cursor movement commands like \x1b[19A (up) and \x1b[999999D (left)
    // For a simple text block, we can convert horizontal cursor shifts (\x1b[41C) into spaces!
    clean = clean.replace(/\x1b\[([0-9]+)C/g, function(match, num) {
        return Array(parseInt(num, 10) + 1).join(" ");
    });

    // Strip remaining vertical cursor jumps that don't map cleanly to plain text rows
    clean = clean.replace(/\x1b\[[0-9]+[A-B]/g, "");
    clean = clean.replace(/\x1b\[[0-9]+[D-E]/g, "");

    // 3. Escape HTML special characters
    clean = clean
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;");

    // 4. Map ANSI colors & styles to HTML tags
    var colorMap = {
        "30": "black",   "90": "gray",
        "31": "red",     "91": "lightcoral",
        "32": "green",   "92": "lightgreen",
        "33": "yellow",  "93": "lightyellow",
        "34": "blue",    "94": "lightblue",
        "35": "magenta", "95": "orchid",
        "36": "cyan",    "96": "lightcyan",
        "37": "white",   "97": "white"
    };

    var bgMap = {
        "40": "black",   "41": "red",     "42": "green",   "43": "yellow",
        "44": "blue",    "45": "magenta", "46": "cyan",    "47": "white"
    };

    // Replace ANSI codes with HTML <font> styling
    clean = clean.replace(/\x1b\[([0-9;]*)m/g, function(match, codes) {
        if (!codes || codes === "0") {
            return "</font></b></s></u>";
        }
        
        var parts = codes.split(";");
        var html = "";
        
        for (var i = 0; i < parts.length; i++) {
            var code = parts[i];
            if (code === "1") {
                html += "<b>";
            } else if (colorMap[code]) {
                html += '<font color="' + colorMap[code] + '">';
            } else if (bgMap[code]) {
                html += '<span style="background-color:' + bgMap[code] + '">';
            } else if (code.indexOf("38;5;") === 0 || code.indexOf("48;5;") === 0) {
                // Extended 256-color support can be skipped or handled generically if needed
            }
        }
        return html;
    });

    // 5. Convert standard newlines to HTML breaks
    clean = clean.replace(/\n/g, "<br>");

    // 6. Preserve multiple spaces for ASCII art alignment
    clean = clean.replace(/ {2,}/g, function(match) {
        return Array(match.length + 1).join("&nbsp;");
    });

    return clean;
}