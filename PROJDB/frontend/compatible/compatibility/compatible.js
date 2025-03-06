const gridViewButton = document.getElementById("grid-view");
const listViewButton = document.getElementById("list-view");
const resultTitle = document.getElementById("results-title")
const searchInput = document.getElementById("search-input");
const searchButton = document.getElementById("search-button");
const clearButton = document.getElementById("clear")
const resultsContainer = document.getElementById("results-container");
const productNameDisplay = document.getElementById("product-name");

let products
let query


searchButton.addEventListener("click", () => {
    query = searchInput.value.trim();
    if (!query) return;
    

    const productsList = query.split(", ");
    
    const list = new Map();
    
    const product = {
        brand:  "",
        model: "",
        category: "" 
    }
    
    for (key in productsList)
    {   
            
            const eachProdcuts = productsList[key].split(" ");
            
            const compatible = Object.create(product) 
            
            compatible.brand    = eachProdcuts[0];
            compatible.model    = eachProdcuts[1];
            compatible.category = eachProdcuts[2];
            
            list.set(key, compatible)
    }

    getCompatibleProducts(list)
});
    
clearButton.addEventListener("click", ()=>{

    searchInput.value = ""
    resultTitle.innerHTML = `<h2 id="results-title">Compatible Products for <span id="product-name">${"..."}</span></h2>`
    productNameDisplay.textContent = "..."
    resultsContainer.innerHTML = ""
})

function displayResults(products) {
    resultsContainer.innerHTML = "";
    resultTitle.innerHTML = `<h2 id="results-title">Compatible Products for <span id="product-name">${query}</span></h2>`
    resultTitle.style.color = "black"

     

    if (typeof(products) === "string") {
        resultTitle.innerHTML = products
        return;
    }

    for (key in products) 
    {  
        for (data in products[key])
        {
            const card = document.createElement("div");
            card.classList.add("product-card");

            const p = products[key][data]
    
            // <img src="${p.image}" alt="${p.name}">
            card.innerHTML = `
            <h3>${p.brand}</h3>
            <p>${p.model}</p>
            <p><strong>${p.category}</strong></p>
            <button>Add to Cart</button>
            `;
            resultsContainer.appendChild(card);
            
        }
    };
}

document.querySelectorAll('input[name="filter"]').forEach(radio => {
    radio.addEventListener("change", () => {
        const selectedCategory = document.querySelector('input[name="filter"]:checked').value;
        const query = searchInput.value.trim();

        if (!query) return;

        if (selectedCategory !== "all")
        {   
            resultsContainer.innerHTML = ""
            
            for (key in products) 
            {  
                if (key == selectedCategory)
                {
                        
                        console.log(key)
                    for (data in products[key])
                    {
                        const card = document.createElement("div");
                        card.classList.add("product-card");
            
                        const p = products[key][data]
                
                        // <img src="${p.image}" alt="${p.name}">
                        card.innerHTML = `
                        <h3>${p.brand}</h3>
                        <p>${p.model}</p>
                        <p><strong>${p.category}</strong></p>
                        <button>Add to Cart</button>
                        `;
                        resultsContainer.appendChild(card);   
                    }
                } 
            }
        }

        else
        {
            displayResults(products);
        }

    });
});

gridViewButton.addEventListener("click", () => {
  resultsContainer.classList.remove("list-view");
  resultsContainer.classList.add("grid-view");
});

listViewButton.addEventListener("click", () => {
  resultsContainer.classList.remove("grid-view");
  resultsContainer.classList.add("list-view");
});


async function getCompatibleProducts(query)
{
    const url = "/compatiblityFinder/compatiblity"
    const userData = localStorage.getItem("userData")
    const res = JSON.parse(userData)
    const token = res["token"]

    const  obj = Object.fromEntries(query)
    
    try
    {
        const response = await fetch(url, {
            method: "POST",
            headers: {"Content-Type": "application/json", "Authorization": token},
            body: JSON.stringify(obj)
        })

        if (response.status == 200)
        {   
            console.log(response.status)
            const result = await response.json()
            products = result
            displayResults(products)
            
        }

        else
        {
            const result = await response.json()
            
            resultTitle.style.color = "red"
            resultTitle.innerHTML = result["error"]
        }
    }

    catch(error)
    {
        console.log(error)
    }
}