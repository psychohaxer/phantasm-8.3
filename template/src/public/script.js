function setLang(lang) {
    const enElements = document.querySelectorAll('.lang-en');
    const idElements = document.querySelectorAll('.lang-id');
    const btnEn = document.getElementById('btn-en');
    const btnId = document.getElementById('btn-id');

    if (lang === 'en') {
        enElements.forEach(el => el.style.display = 'block');
        idElements.forEach(el => el.style.display = 'none');
        btnEn.classList.add('active');
        btnId.classList.remove('active');
    } else {
        enElements.forEach(el => el.style.display = 'none');
        idElements.forEach(el => el.style.display = 'block');
        btnEn.classList.remove('active');
        btnId.classList.add('active');
    }
}

// Auto-detect browser language or default to English
document.addEventListener('DOMContentLoaded', () => {
    const userLang = navigator.language || navigator.userLanguage;
    if (userLang.startsWith('id')) {
        setLang('id');
    } else {
        setLang('en');
    }
});
