/* IDIOT site minimal JS */

document.addEventListener('DOMContentLoaded', () => {
  const stamp = new Date().toISOString();
  const el = document.querySelector('[data-build-stamp]');
  if (el) el.textContent = stamp;

  // Smooth scroll for internal anchors
  document.querySelectorAll('a[href^="#"]').forEach(a => {
    a.addEventListener('click', e => {
      const id = a.getAttribute('href').slice(1);
      const target = document.getElementById(id);
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth' });
      }
    });
  });

  // Basic nav highlight
  const here = location.pathname.split('/').pop();
  document.querySelectorAll('nav a').forEach(a => {
    if (a.getAttribute('href') === here) a.classList.add('active');
  });
});
