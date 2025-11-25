**Everything RUNS ON ECLIPSE EE, ONLY USE VSCODE FOR HTML/CSS**
**ALL files go into WEBAPP / JAVA DOES NOT GO INTO WEBAPP**

**SQL NEEDED NO LONGER USING JSON**

## 🎨 I. Frontend & Visual Effects

### 1. Animations & Interactivity (GSAP)
We utilized **GreenSock Animation Platform (GSAP)** to drive complex UI interactions:
* **Cinematic Splash Screen:** On load, the brand name splits into individual characters and animates upward with a stagger effect, while the background dissolves to reveal the UI.
* **Infinite Moving Gallery:** A custom JavaScript engine clones the home page product cards and translates them infinitely along the X-axis to create a seamless, never-ending marquee.
* **Micro-Interactions:**
    * **Error Feedback:** If a user tries to add a product without selecting a size, the size container vibrates (X-axis wobble) to signal the error.
    * **Page Transitions:** Glass cards and grids utilize `fadeInUp` animations for a smooth entry.

### 2. Particle Effects
* **Canvas Confetti:** A physics-based particle library is triggered on key "Success" actions (Add to Cart, Wishlist Toggle, Order Completion), bursting colorful confetti from the specific button coordinates.

### 3. UI Architecture
* **Glassmorphism Theme:** We overrode **Bootstrap 5** defaults to create a semi-transparent, blurred aesthetic. Using `backdrop-filter: blur(12px)` and RGBA colors, the UI elements (Navbar, Cards) float above the background.
* **Masonry Layout:** A pure CSS Column layout (not Grid) allows image cards of varying aspect ratios to stack tightly like bricks, creating a dynamic "Pinterest-style" gallery.

---

## ⚙️ II. Backend Architecture

The application follows the **MVC (Model-View-Controller)** design pattern running on **Apache Tomcat 10**.

### 1. The "Smart" Navbar (JSP)
We migrated from static `.html` to dynamic `.jsp` files to handle session states.
* **Logic:** The navbar checks `session.getAttribute("user_id")` on every page load.
* **State:**
    * *Guest:* Displays the Login/Register Dropdown form.
    * *User:* Displays "Welcome, [Name]", Link to Dashboard, and Logout button.

### 2. Data Flow
* **Model (Java Beans):** Represents data objects (`Product.java`, `CartItem.java`, `Address.java`, `Order.java`).
* **View (JSP):** Displays data using SQL queries inside scriptlet tags. Includes reusable components like `navbar_partial.jsp`.
* **Controller (Servlets):** Handles business logic:
    * `LoginServlet` / `LogoutServlet`: Session management.
    * `GetProductsServlet`: Fetches inventory from SQL and outputs JSON for the frontend.
    * `AddToCartServlet` / `PlaceOrderServlet`: Handles transactional logic.

### 3. Database (MySQL)
* **`products`:** Stores item details. Complex attributes (Sizes, Colors, Badges) are stored as JSON-like text strings (e.g., `["S", "M"]`) to simplify the schema.
* **`cart_items` & `wishlist`:** Relational tables mapping `user_id` to `product_id`.
* **`orders` & `order_items`:** When an order is placed, data is moved from the volatile *Cart* table to the permanent *Order History* tables.

---

## 🔍 III. Filtering & Sorting Engine

The gallery page features a high-performance, client-side filtering engine.

* **Zero-Latency:** We fetch the full product catalog **once** (`GetProductsServlet`) and cache it in a global JavaScript array (`allProducts`). Filters run instantly without reloading the page.
* **Chained Logic:** The `applyFilters()` function uses JavaScript’s `.filter()` to check multiple conditions simultaneously. A product is only shown if it passes **ALL** active checks:
    1.  **Category:** Matches URL parameter (e.g., `?category=men`).
    2.  **Price:** Checks against the range slider value.
    3.  **Type:** Matches selected checkboxes (Shoe, Hoodie, etc.).
    4.  **Attributes:** Checks if the product’s `colors` or `sizes` arrays contain the user's selection.
* **Dynamic Sorting:** JavaScript’s `.sort()` reorders the array (Price Low-High, Newest ID) before the grid is re-rendered.

---

## 🛠️ IV. Setup Instructions

1.  **Database:**
    * Open MySQL Workbench.
    * Create schema `account_db`.
    * Run the provided `SQL_Setup_Script.sql` to create tables (`users`, `products`, `cart_items`, `wishlist`, `orders`, `addresses`).
2.  **IDE:**
    * Import project into **Eclipse IDE for Enterprise Java**.
    * Target Runtime: **Apache Tomcat v10.1**.
3.  **Dependencies:**
    * Ensure `mysql-connector-j-8.x.x.jar` is in `src/main/webapp/WEB-INF/lib`.
4.  **Run:**
    * Right-click `home.jsp` -> Run As -> Run on Server.

---

*© 2025 Arcadia Wear Project Team*
