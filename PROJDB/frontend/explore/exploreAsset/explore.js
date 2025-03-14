// Fetch products from the Go backend
async function fetchProducts() {
    try {
        console.log()
        const response = await fetch('/products');
        const products = await response.json();

        // Get the product grid container
        const productGrid = document.getElementById('product-grid');

        // Clear existing products
        productGrid.innerHTML = '';

        // Render each product as a card
        products.forEach(product => {
            const card = document.createElement('div');
            card.className = 'product-card';

            // Convert image data to base64 if available
            // let imgSrc = '';
            // if (product.Image_address) {
            //     // imgSrc = 'data:image/jpeg;base64,' + btoa(
            //     //     String.fromCharCode.apply(null, new Uint8Array(product.image))
            //     // );
            //     console.log("hiii");
            //     imgSrc = product.Image_address;
            // } else {
            //     imgSrc = '/exploreAsset/no-image.jpg'; // Default image if no image exists
            // }
            // imgSrc = product.Image_address;
            // console.log (imgSrc)
            card.innerHTML = `
                <img class="product-image" src="${product.Image_address}" alt="${product.Image_address}">
                <h3>${product.model}</h3>
                <p><strong>Brand:</strong> ${product.brand}</p>
                <p><strong>Category:</strong> ${product.category}</p>
                <p class="price">$${product.current_price}</p>
            `;

            productGrid.appendChild(card);
        });
    } catch (error) {
        console.error('Error fetching products:', error);
    }
}

// Call the function when the page loads
window.onload = fetchProducts;