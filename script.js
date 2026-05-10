  const hints = ['hot', 'cold', 'hungry', 'tired', 'bored', 'happy', 'sad', 'rainy', 'spicy', 'active'];

        // Render hint chips
        const hintEl = document.getElementById('hints');
        hints.forEach(h => {
            const chip = document.createElement('span');
            chip.className = 'hint';
            chip.textContent = h;
            chip.onclick = () => { document.getElementById('query').value = h; search(); };
            hintEl.appendChild(chip);
        });

        // Enter key
        document.getElementById('query').addEventListener('keydown', e => {
            if (e.key === 'Enter') search();
        });

        async function search() {
            const q = document.getElementById('query').value.trim();
            if (!q) return;

            const section = document.getElementById('results-section');
            const container = document.getElementById('results');
            document.getElementById('query-echo').textContent = `"${q}"`;
            section.style.display = 'block';
            container.innerHTML = '<p class="no-result">Searching...</p>';

            try {
                const res = await fetch(`recommend.php?q=${encodeURIComponent(q)}`);
                const data = await res.json();

                if (!data.results.length) {
                    container.innerHTML = '<p class="no-result">No match found. Try another keyword.</p>';
                    return;
                }

                container.innerHTML = data.results.map(r => `
          <div class="result-card">
            <div class="result-left">
              <div class="result-name">${r.recommendation}</div>
              <div class="result-keyword">matched: <span>${r.keyword}</span></div>
            </div>
            <div class="result-tag">${r.category}</div>
          </div>
        `).join('');

            } catch {
                container.innerHTML = '<p class="no-result">Error connecting to server.</p>';
            }
        }

        let catalogLoaded = false;
        let catalogOpen = false;

        async function toggleCatalog() {
            const el = document.getElementById('catalog');
            catalogOpen = !catalogOpen;
            el.style.display = catalogOpen ? 'block' : 'none';
            document.querySelector('.catalog-toggle').textContent =
                catalogOpen ? '[ hide catalog ]' : '[ view full catalog ]';

            if (catalogOpen && !catalogLoaded) {
                const res = await fetch('recommend.php?all=true');
                const data = await res.json();
                const grid = document.getElementById('catalog-grid');
                grid.innerHTML = data.results.map(i => `
          <div class="cat-row">
            <span class="cat-kw">${i.keyword}</span>
            <span class="cat-rec">${i.recommendation}</span>
          </div>
        `).join('');
                catalogLoaded = true;
            }
        }