// Draggable sidebar resizer. Drag the handle to resize; double-click to reset.
// Width is stored in the CSS variable --sidebar-width and persisted to localStorage.
window.appUi = {
    initResizer: function () {
        try {
            var saved = localStorage.getItem('lh-sidebar-width');
            if (saved) {
                document.documentElement.style.setProperty('--sidebar-width', saved);
            }
        } catch (e) { /* ignore */ }

        var resizer = document.querySelector('.sidebar-resizer');
        if (!resizer || resizer.dataset.init === '1') {
            return;
        }
        resizer.dataset.init = '1';

        var dragging = false;
        var minWidth = 180;
        var maxWidth = 640;

        function clientX(e) {
            return e.touches && e.touches.length ? e.touches[0].clientX : e.clientX;
        }

        function onMove(e) {
            if (!dragging) { return; }
            var width = Math.max(minWidth, Math.min(maxWidth, clientX(e)));
            document.documentElement.style.setProperty('--sidebar-width', width + 'px');
        }

        function stop() {
            if (!dragging) { return; }
            dragging = false;
            document.body.style.userSelect = '';
            document.body.style.cursor = '';
            try {
                var w = getComputedStyle(document.documentElement).getPropertyValue('--sidebar-width').trim();
                localStorage.setItem('lh-sidebar-width', w);
            } catch (e) { /* ignore */ }
        }

        resizer.addEventListener('mousedown', function () {
            dragging = true;
            document.body.style.userSelect = 'none';
            document.body.style.cursor = 'col-resize';
        });
        resizer.addEventListener('touchstart', function () { dragging = true; }, { passive: true });
        window.addEventListener('mousemove', onMove);
        window.addEventListener('touchmove', onMove, { passive: true });
        window.addEventListener('mouseup', stop);
        window.addEventListener('touchend', stop);

        resizer.addEventListener('dblclick', function () {
            document.documentElement.style.setProperty('--sidebar-width', '280px');
            try { localStorage.setItem('lh-sidebar-width', '280px'); } catch (e) { /* ignore */ }
        });
    },

    // Resizer for the docked right-hand TOC pane. The handle sits on the pane's
    // LEFT edge and is (re)created by Blazor whenever the pane is shown, so we use
    // event delegation on the document instead of binding to a specific element.
    initTocResizer: function () {
        if (window.__lhTocResizerInit) { return; }
        window.__lhTocResizerInit = true;

        try {
            var saved = localStorage.getItem('lh-toc-width');
            if (saved) {
                document.documentElement.style.setProperty('--toc-width', saved);
            }
        } catch (e) { /* ignore */ }

        var dragging = false;
        var minWidth = 180;
        var maxWidth = 560;

        function clientX(e) {
            return e.touches && e.touches.length ? e.touches[0].clientX : e.clientX;
        }

        function onMove(e) {
            if (!dragging) { return; }
            // Pane is docked to the right edge; width grows as the pointer moves left.
            var width = Math.max(minWidth, Math.min(maxWidth, window.innerWidth - clientX(e)));
            document.documentElement.style.setProperty('--toc-width', width + 'px');
        }

        function stop() {
            if (!dragging) { return; }
            dragging = false;
            document.body.style.userSelect = '';
            document.body.style.cursor = '';
            try {
                var w = getComputedStyle(document.documentElement).getPropertyValue('--toc-width').trim();
                if (w) { localStorage.setItem('lh-toc-width', w); }
            } catch (e) { /* ignore */ }
        }

        document.addEventListener('mousedown', function (e) {
            if (e.target && e.target.classList && e.target.classList.contains('toc-resizer')) {
                dragging = true;
                document.body.style.userSelect = 'none';
                document.body.style.cursor = 'col-resize';
                e.preventDefault();
            }
        });
        document.addEventListener('dblclick', function (e) {
            if (e.target && e.target.classList && e.target.classList.contains('toc-resizer')) {
                document.documentElement.style.setProperty('--toc-width', '260px');
                try { localStorage.setItem('lh-toc-width', '260px'); } catch (e2) { /* ignore */ }
            }
        });
        window.addEventListener('mousemove', onMove);
        window.addEventListener('touchmove', onMove, { passive: true });
        window.addEventListener('mouseup', stop);
        window.addEventListener('touchend', stop);
    }
};
