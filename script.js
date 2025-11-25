let selectedSize = null;

// --- GENEATE THE SCHEMATICS --
const schematics = {
  shoe: `<img src="img/shoe_schematic.png" class="schematic-img" alt="Shoe Blueprint">`,
  hoodie: ``,
  shirt: ``,
  default: ``
};

//SIDEBAR
var toggleBtn = document.getElementById('toggleSidebar');
var sidebar = document.getElementById('sidebar');

if (toggleBtn) {
  toggleBtn.onclick = function () {
    if (sidebar.classList.contains('open')) {
      sidebar.classList.remove('open');
    } else {
      sidebar.classList.add('open');
    }
  }
}

const closeBtn = document.getElementById('closeSidebar');
if (closeBtn) {
  closeBtn.onclick = function () {
    sidebar.classList.remove('open');
  }
}

//detect page
document.addEventListener("DOMContentLoaded", () => {

  //home
  const productContainer = document.getElementById("product-container-dynamic");
  if (productContainer) {
    loadProducts();
  }

  //called it gallery but its just the default view not home
  const galleryGrid = document.getElementById("gallery-grid");
  if (galleryGrid) {
    loadGallery();
  }

  //product page
  const detailImg = document.getElementById("detail-img");
  if (detailImg) {
    loadProductDetails();
  }

  //for all
  initSplash();
  initNavbarScroll();
});

function handleLogin(event) {
  event.preventDefault(); // Stop page reload

  // Check if Captcha is checked
  const response = grecaptcha.getResponse();

  if (response.length === 0) {
    // Captcha not checked
    const btn = event.target.querySelector('button[type="submit"]');

    // Shake animation for error
    gsap.to(event.target, { x: -10, duration: 0.1, repeat: 5, yoyo: true, onComplete: () => { gsap.set(event.target, { x: 0 }); } });

    btn.innerText = "Please Verify Captcha";
    btn.classList.add('btn-danger');

    setTimeout(() => {
      btn.innerText = "LOG IN";
      btn.classList.remove('btn-danger');
    }, 2000);
    return;
  }

  // If valid, proceed (Simulate login)
  const btn = event.target.querySelector('button[type="submit"]');
  btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Processing';

  setTimeout(() => {
    btn.innerHTML = 'Welcome Back!';
    btn.classList.add('btn-success');
    triggerConfetti(btn); // Re-using your confetti function!

    // Close dropdown after delay
    setTimeout(() => {
      const dropdownBtn = document.getElementById('loginDropdownBtn');
      const bsDropdown = bootstrap.Dropdown.getInstance(dropdownBtn);
      bsDropdown.hide();
      // Reset form
      event.target.reset();
      grecaptcha.reset();
      btn.innerHTML = "LOG IN";
      btn.classList.remove('btn-success');
    }, 1500);
  }, 1000);
}
//HOME
async function loadProducts() {
  try {
    const response = await fetch('GetProductsServlet');
    if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`); //error 

    const products = await response.json();
    const productContainer = document.getElementById("product-container-dynamic");

    productContainer.innerHTML = '';

    // Generate Cards
    products.forEach(product => {
      const productHTML = createProductCard(product);
      productContainer.insertAdjacentHTML('beforeend', productHTML);
    });

    //this is whaat allows the scrolling effect.
    const originalContent = productContainer.innerHTML;
    productContainer.insertAdjacentHTML('beforeend', originalContent);

    startMarquee(productContainer);


  } catch (error) {
    console.error("Could not load products:", error);
  }
}

//gallery page again i just called it that.

// GLOBAL VARIABLES to store current state
let allProducts = [];// GLOBAL VARIABLES
let currentCategory = 'all';

async function loadGallery() {
  const params = new URLSearchParams(window.location.search);
  currentCategory = params.get('category') || 'all';

  // Update Title based on URL
  const titleEl = document.getElementById('gallery-title');
  if (titleEl) {
    if (currentCategory === 'new-arrivals') titleEl.innerText = "NEW ARRIVALS";
    else if (currentCategory === 'all') titleEl.innerText = "FULL COLLECTION";
    else titleEl.innerText = currentCategory.toUpperCase() + "'S COLLECTION";
  }

  try {
    const response = await fetch('GetProductsServlet');
    const data = await response.json(); // Store in temp variable first

    // CRITICAL FIX: Assign data to the global variable
    allProducts = data;

    // Initial Render
    applyFilters();

  } catch (e) {
    console.error("Error loading gallery:", e);
  }
}

// TOGGLE BUTTON VISUAL STATE (For Size/Color)
function toggleFilterBtn(btn) {
  btn.classList.toggle('active');
  // If it's a color button, add a border/ring effect
  if (btn.classList.contains('filter-color')) {
    btn.style.boxShadow = btn.classList.contains('active') ? '0 0 0 3px var(--col-accent)' : 'none';
  } else {
    // Standard button
    btn.classList.toggle('btn-secondary');
    btn.classList.toggle('btn-outline-secondary');
  }
}

// MAIN FILTER & SORT FUNCTION
function applyFilters() {
  const grid = document.getElementById("gallery-grid");
  grid.innerHTML = '';

  // 1. GET FILTER VALUES
  const maxPrice = parseInt(document.getElementById('priceRange').value);

  // Get checked Types
  const checkedTypes = Array.from(document.querySelectorAll('.filter-type:checked')).map(cb => cb.value);

  // Get active Sizes
  const activeSizes = Array.from(document.querySelectorAll('.filter-size.active')).map(btn => btn.getAttribute('data-size'));

  // Get active Colors
  const activeColors = Array.from(document.querySelectorAll('.filter-color.active')).map(btn => btn.getAttribute('data-color'));

  // 2. FILTER LOGIC
  let filtered = allProducts.filter(p => {
    // Category Filter (From URL)
    if (currentCategory !== 'all' && !p.categories.includes(currentCategory)) return false;

    // Price Filter
    if (p.price > maxPrice) return false;

    // Type Filter (if any are checked, product must match one)
    if (checkedTypes.length > 0 && !checkedTypes.includes(p.type)) return false;

    // Size Filter (product must have AT LEAST ONE of the selected sizes)
    // If no sizes selected, show all.
    if (activeSizes.length > 0) {
      const hasSize = p.sizes.some(s => activeSizes.includes(s));
      if (!hasSize) return false;
    }

    // Color Filter
    // Color Filter
    if (activeColors.length > 0) {
      // Check if the product has a 'colors' array and if it overlaps with selected filters
      if (!p.colors || !Array.isArray(p.colors)) return false;

      const hasColor = p.colors.some(c => activeColors.includes(c));
      if (!hasColor) return false;
    }

    return true;
  });

  // 3. SORTING LOGIC
  // You need to update your Sort Dropdown HTML to call sortGallery(this.value) or read a value here.
  // For now, let's look for a global sort variable or just default.
  // Let's assume you have a select with ID 'sortSelect' (Add this to your HTML dropdown items)

  // (We can implement dynamic sorting on click later, for now let's just render)

  // 4. RENDER
  if (filtered.length === 0) {
    grid.innerHTML = '<div class="col-12 text-center py-5"><h4>No products found matching your filters.</h4></div>';
  } else {
    filtered.forEach((product, index) => {
      const cardHTML = createGridCard(product, index);
      grid.insertAdjacentHTML('beforeend', cardHTML);
    });

    // Animation
    gsap.from(".gallery-col", {
      y: 50, opacity: 0, duration: 0.6, stagger: 0.1, ease: "power2.out"
    });
  }
}

// Add Sorting Functionality
function sortProducts(sortType) {
  // 1. Sort the GLOBAL array
  if (sortType === 'low-high') {
    allProducts.sort((a, b) => a.price - b.price);
  } else if (sortType === 'high-low') {
    allProducts.sort((a, b) => b.price - a.price);
  } else if (sortType === 'newest') {
    allProducts.sort((a, b) => b.id - a.id);
  }

  // 2. Update button text visually
  const sortLabel = sortType.replace('-', ' to ').toUpperCase();
  const dropdownBtn = document.getElementById('sortDropdown');
  if (dropdownBtn) dropdownBtn.innerText = 'Sort By: ' + sortLabel;

  // 3. Re-apply filters (this will render the sorted list respecting the filters)
  applyFilters();
}

function createGridCard(product, index) {

  const starsHtml = generateStars(product.rating);
  const badgesHtml = product.badges.map(badge => `<span class="custom-badge">${badge}</span>`).join('');

  //remove h-10
  return `
    <div class="col-12 col-md-6 col-lg-3 mb-5 gallery-col">
      <div class="card custom-product-card">
        <a href="product.jsp?id=${product.id}" style="text-decoration: none; display: block;">
          <div class="card-image-header">
             <img src="${product.image}" alt="${product.title}">
          </div>
        </a>
        <div class="card-details-body">
          <a href="product.jsp?id=${product.id}" style="text-decoration: none; color: inherit;">
            <h5 class="product-title">${product.title}</h5>
          </a>
          <div class="star-rating">${starsHtml}</div>
          <div class="badge-container">${badgesHtml}</div>
          <p class="product-description">${product.description}</p>
          <div class="card-bottom-actions">
             <div class="price-tag">
               <img src="img/UAE_Dirham_Symbol.svg" class="dhs_icon_sm"> ${product.price}
             </div>
             <div class="action-buttons-row">
                <button class="btn btn-add-cart" data-id="${product.id}" onclick="addToCart(this)">Add to cart</button>
                <button class="btn-wishlist" data-id="${product.id}" onclick="toggleWishlist(this, event)">
                  <i class="fa fa-heart-o"></i>
                </button>
             </div>
          </div>
        </div>
      </div>
    </div>
    `;
}

//common for js.
function createProductCard(product) {
  const starsHtml = generateStars(product.rating);
  const badgesHtml = product.badges.map(badge => `<span class="custom-badge">${badge}</span>`).join('');

  return `
    <div class="gallery-item">
      <div class="card custom-product-card">
        <a href="product.jsp?id=${product.id}" style="text-decoration: none; display: block;">
          <div class="card-image-header">
             <img src="${product.image}" alt="${product.title}">
          </div>
        </a>
        <div class="card-details-body">
          <a href="product.jsp?id=${product.id}" style="text-decoration: none; color: inherit;">
            <h5 class="product-title">${product.title}</h5>
          </a>
          <div class="star-rating">${starsHtml}</div>
          <div class="badge-container">${badgesHtml}</div>
          <p class="product-description">${product.description}</p>
          <div class="card-bottom-actions">
             <div class="price-tag">
               <img src="img/UAE_Dirham_Symbol.svg" class="dhs_icon_sm"> ${product.price}
             </div>
             <div class="action-buttons-row">
                <button class="btn btn-add-cart" data-id="${product.id}" onclick="addToCart(this)">Add to cart</button>
                <button class="btn-wishlist" data-id="${product.id}" onclick="toggleWishlist(this, event)">
                  <i class="fa fa-heart-o"></i>
                </button>
             </div>
          </div>
        </div>
      </div>
    </div>
  `;
}

function generateStars(rating) {
  let starsHtml = '';
  for (let i = 1; i <= 5; i++) {
    starsHtml += (i <= rating) ? '<i class="fa fa-star"></i> ' : '<i class="fa fa-star-o" style="color: #ccc;"></i> ';
  }
  return starsHtml;
}

function startMarquee(container) {
  const totalWidth = container.scrollWidth;
  const duration = totalWidth / 100;

  const marquee = gsap.to(container, {
    x: "-50%",
    ease: "none",
    duration: duration,
    repeat: -1
  });

  container.addEventListener("mouseenter", () => marquee.pause());
  container.addEventListener("mouseleave", () => marquee.play());
}

//product page

async function loadProductDetails() {
  const params = new URLSearchParams(window.location.search);
  const productId = params.get('id');

  if (!productId) {
    window.location.href = 'home.jsp';
    return;
  }

  try {
    const response = await fetch('GetProductsServlet');
    const products = await response.json();
    const product = products.find(p => p.id == productId);

    if (product) {
      // Populate Info
      document.getElementById('detail-img').src = product.image;
      document.getElementById('detail-title').innerText = product.title;
      document.getElementById('detail-price').innerHTML = `<img src="img/UAE_Dirham_Symbol.svg" class="dhs_icon_sm" alt="Dhs"> ${product.price}`;
      document.getElementById('detail-desc').innerText = product.description;
      document.getElementById('detail-type').innerText = product.type ? product.type.toUpperCase() : 'COLLECTION';

      document.getElementById('detail-rating').innerHTML = generateStars(product.rating);

      const bigCartBtn = document.getElementById('addToCartBtn');
      if (bigCartBtn) {
        bigCartBtn.setAttribute('data-id', product.id);
      }
      const badgesContainer = document.getElementById('detail-badges');
      badgesContainer.innerHTML = product.badges.map(b => `<span class="badge bg-secondary me-2 p-2">${b}</span>`).join('');

      //sizes are here
      const sizeContainer = document.getElementById('size-container');
      sizeContainer.innerHTML = '';
      selectedSize = null;

      if (product.sizes && product.sizes.length > 0) {
        product.sizes.forEach(size => {
          const btn = document.createElement('button');
          btn.className = 'btn btn-outline-dark size-btn';
          btn.innerText = size;
          btn.onclick = () => {
            document.querySelectorAll('.size-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            selectedSize = size;
            document.getElementById('size-error').classList.add('d-none');
          };
          sizeContainer.appendChild(btn);
        });
      } else {
        sizeContainer.innerHTML = '<span class="text-muted">One Size Only</span>';
        selectedSize = 'One Size';
      }

      //more work on this follows with css
      if (product.measurements) {
        document.getElementById('meas-label-1').innerText = product.measurements.Label || "Dimension A";
        document.getElementById('meas-val-1').innerText = product.measurements.Value || "--";
        document.getElementById('meas-label-2').innerText = product.measurements.Label_2 || "Dimension B";
        document.getElementById('meas-val-2').innerText = product.measurements.Value_2 || "--";
        document.getElementById('diag-text').innerText = product.measurements.DiagramText || "Spec";
      }



      const type = product.type ? product.type.toLowerCase() : 'default';
      const schematicHTML = schematics[type] || schematics.default;
      const schematicContainer = document.getElementById('schematic-placeholder');
      if (schematicContainer) {
        schematicContainer.innerHTML = schematicHTML;
        gsap.fromTo(".schematic-img", { opacity: 0, scale: 0.9 }, { opacity: 1, scale: 1, duration: 1, ease: "power2.out", delay: 0.2 });
      }

      document.getElementById('loading-msg').classList.add('d-none');
      document.getElementById('product-content').classList.remove('d-none');
      gsap.from("#detail-img", { opacity: 0, x: -50, duration: 1 });
      gsap.from(".product-info-panel", { opacity: 0, x: 50, duration: 1, delay: 0.2 });

    } else {
      document.getElementById('loading-msg').innerHTML = "<h2>Product not found.</h2>";
    }
  } catch (error) {
    console.error(error);
  }
}

function addToCartProductPage(btn) {
  if (!selectedSize) {
    const errorMsg = document.getElementById('size-error');
    errorMsg.classList.remove('d-none');
    gsap.fromTo("#size-container", { x: -10 }, { x: 10, duration: 0.1, repeat: 3, yoyo: true, onComplete: () => { gsap.set("#size-container", { x: 0 }); } });
    return;
  }
  addToCart(btn);
}

function toggleProductPageWishlist(btn, event) {
  btn.classList.toggle('active');
  const icon = btn.querySelector('i');
  if (btn.classList.contains('active')) {
    icon.classList.remove('fa-heart-o');
    icon.classList.add('fa-heart');
    icon.style.color = '#ff4d6d';
    triggerConfetti(btn);
  } else {
    icon.style.color = '#ccc';
  }
}


//more common, move this up
function triggerConfetti(btn) {
  const rect = btn.getBoundingClientRect();
  const x = (rect.left + rect.width / 2) / window.innerWidth;
  const y = (rect.top + rect.height / 2) / window.innerHeight;
  confetti({ particleCount: 60, spread: 70, origin: { x: x, y: y }, colors: ['#ff4d6d', '#5e548e', '#ffffff'], disableForReducedMotion: true, zIndex: 9999 });
}

function toggleWishlist(btn, event) {
  // Prevent button from submitting forms if inside one
  if (event) event.preventDefault();

  // Get Product ID from the button's data attribute
  const productId = btn.getAttribute('data-id');
  if (!productId) {
    console.error("No product ID found on wishlist button");
    return;
  }

  // Visual toggle immediately (optimistic UI)
  const icon = btn.querySelector('i');
  const wasActive = btn.classList.contains('active');
  btn.classList.toggle('active');

  if (!wasActive) {
    // It is now active
    if (icon) {
      icon.classList.remove('fa-heart-o');
      icon.classList.add('fa-heart');
      icon.style.color = '#ff4d6d';
    }
    triggerConfetti(btn);
  } else {
    // It is now inactive
    if (icon) {
      icon.classList.remove('fa-heart');
      icon.classList.add('fa-heart-o');
      icon.style.color = ''; // Reset color
    }
  }

  // Send to Backend
  fetch('ToggleWishlistServlet', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `product_id=${productId}`
  })
    .then(response => {
      if (response.status === 401) {
        // User not logged in -> redirect to login or show alert
        window.location.href = 'create_account.jsp'; // or trigger login modal
      } else if (!response.ok) {
        // Revert change if server failed
        btn.classList.toggle('active');
        alert("Something went wrong. Please try again.");
      }
    });
}

function addToCart(btn) {
  // 1. Visual Loading State
  if (btn.classList.contains('loading') || btn.classList.contains('success')) return;

  const isProductPage = btn.id === 'addToCartBtn';

  // Validation: If on product page, ensure size is selected
  // (Your existing addToCartProductPage function handles the UI error, 
  // but we need to pass the size to the backend)
  let sizeToSend = 'One Size';
  if (isProductPage) {
    if (!selectedSize) {
      // If no size selected, don't send to backend (animation handled by wrapper func)
      return;
    }
    sizeToSend = selectedSize;
  }

  // 2. Get Product ID
  // If we are on the grid, we need to find the ID. 
  // We don't have data-id on the cart button yet! We need to fix that HTML.
  // CHECK: Does the button closest parent have an ID?
  // Let's assume we add data-id to the Add Cart button in the HTML generator (Step 4)
  const productId = btn.getAttribute('data-id');

  if (!productId) {
    console.error("Product ID missing");
    return;
  }

  // 3. Send to Backend
  btn.classList.add('loading');
  if (isProductPage) btn.innerText = "";

  fetch('AddToCartServlet', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `product_id=${productId}&size=${encodeURIComponent(sizeToSend)}`
  })
    .then(response => {
      if (response.status === 401) {
        window.location.href = 'create_account.jsp'; // Redirect if not logged in
      } else if (response.ok) {
        // Success Animation
        setTimeout(() => {
          btn.classList.remove('loading');
          btn.classList.add('success');
          // If product page, show specific text
          btn.innerHTML = isProductPage ? `ADDED (Size ${sizeToSend})` : 'Added!';

          setTimeout(() => {
            btn.classList.remove('success');
            if (isProductPage) btn.innerText = "ADD TO CART";
            else btn.innerHTML = "Add to cart"; // Reset text
          }, 2000);
        }, 500);
      } else {
        alert("Error adding to cart");
        btn.classList.remove('loading');
      }
    });
}



function initSplash() {
  const splashScreen = document.getElementById("splash-screen");
  const splashText = document.getElementById("splash-text");
  const navbarBrand = document.querySelector(".navbar-brand");
  if (!splashScreen || !splashText || !navbarBrand) return;

  const brandRect = navbarBrand.getBoundingClientRect();
  const startRect = splashText.getBoundingClientRect();
  const deltaY = brandRect.top - startRect.top;

  const textContent = splashText.innerText;
  splashText.innerHTML = textContent.split("").map(char => char === " " ? `<span class="split-char">&nbsp;</span>` : `<span class="split-char">${char}</span>`).join("");

  const tl = gsap.timeline();
  tl.from(".split-char", { duration: 0.8, y: 80, opacity: 0, stagger: 0.05, ease: "back.out(1.7)" })
    .to({}, { duration: 0.3 })
    .to(splashText, { duration: 1.2, y: deltaY, scale: 0.4, color: "#F5F5DC", ease: "power3.inOut" }, "move")
    .to(splashScreen, { duration: 1, opacity: 0, ease: "power2.inOut", pointerEvents: "none" }, "move+=0.1")
    .add(() => {
      splashScreen.style.display = "none";
      gsap.set(navbarBrand, { opacity: 1 });
      gsap.to(".flow-item", { x: 0, opacity: 1, stagger: 0.1 });
    });
}

function initNavbarScroll() {
  const navbar = document.querySelector('.navbar');
  window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
      navbar.classList.add('navbar-glass');
      navbar.classList.remove('bg-darkblue');
    } else {
      navbar.classList.remove('navbar-glass');
      navbar.classList.add('bg-darkblue');
    }
  });

  const textElement = document.getElementById('rotating-text');
  if (textElement) {
    const phrases = ["FALL COLLECTION", "DISCOVER MEN", "DISCOVER WOMEN", "URBAN CLASSICS"];
    let index = 0;
    setInterval(() => {
      index = (index + 1) % phrases.length;
      gsap.to(textElement, {
        duration: 0.5, y: -30, opacity: 0, ease: "power2.in",
        onComplete: () => {
          textElement.innerText = phrases[index];
          gsap.set(textElement, { y: 30 });
          gsap.to(textElement, { duration: 0.8, y: 0, opacity: 1, ease: "elastic.out(1, 0.6)" });
        }
      });
    }, 3500);
  }
}

function removeFromWishlist(btn) {
  const productId = btn.getAttribute('data-id');


  fetch('ToggleWishlistServlet', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `product_id=${productId}`
  })
    .then(response => {
      if (response.ok) {
        //animation here
        const cardCol = btn.closest('.col-md-6');
        gsap.to(cardCol, {
          opacity: 0,
          scale: 0.9,
          duration: 0.3,
          onComplete: () => cardCol.remove()
        });
      } else {
        alert("Could not remove item.");
      }
    });
}

//CHECKLOUTUTUTT

window.addEventListener('DOMContentLoaded', () => {
  const cards = document.querySelectorAll('.address-card');
  if (cards.length > 0) {
    cards[0].click(); // first avlaible
  }

  //synicing inputs
  const manualInputs = document.querySelectorAll('.manual-input');
  manualInputs.forEach(input => {
    input.addEventListener('input', syncManualInputs);
    input.addEventListener('change', syncManualInputs);
  });
});

function selectAddress(card, fullName, addr, city, state) {
  // 1. Visuals
  document.querySelectorAll('.address-card').forEach(c => {
    c.classList.remove('border-primary', 'bg-light');
    c.querySelector('input[type="radio"]').checked = false;
  });
  card.classList.add('border-primary', 'bg-light');
  card.querySelector('input[type="radio"]').checked = true;

  // 2. Hide Manual Form
  document.getElementById('manual-address-form').classList.add('d-none');

  // 3. Populate Hidden Fields
  // Split name blindly (First word = First Name, Rest = Last Name)
  const nameParts = fullName.split(" ");
  const fName = nameParts[0];
  const lName = nameParts.slice(1).join(" ") || "."; // Default dot if no last name

  document.getElementById('h_fname').value = fName;
  document.getElementById('h_lname').value = lName;
  document.getElementById('h_addr').value = addr;
  document.getElementById('h_city').value = city;
  document.getElementById('h_emirate').value = state;
}

function toggleManualAddress() {
  // Clear visual selection
  document.querySelectorAll('.address-card').forEach(c => {
    c.classList.remove('border-primary', 'bg-light');
    c.querySelector('input[type="radio"]').checked = false;
  });

  // Show form
  document.getElementById('manual-address-form').classList.remove('d-none');

  // Clear hidden inputs so manual inputs take over via sync function
  syncManualInputs();
}

function syncManualInputs() {
  document.getElementById('h_fname').value = document.getElementById('m_fname').value;
  document.getElementById('h_lname').value = document.getElementById('m_lname').value;
  document.getElementById('h_addr').value = document.getElementById('m_addr').value;
  document.getElementById('h_city').value = document.getElementById('m_city').value;
  document.getElementById('h_emirate').value = document.getElementById('m_emirate').value;
}