# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     JustTravelTestBackend.Repo.insert!(%JustTravelTestBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias JustTravelTestBackend.{Repo, Cart, CartItem, Item}

# insert 10 usual random items
Repo.insert(%Item{name: "Banana", description: "A banana", price: 3.0})
Repo.insert(%Item{name: "Apple", description: "An apple", price: 2.0})
Repo.insert(%Item{name: "Milk", description: "A milk", price: 5.0})
Repo.insert(%Item{name: "Orange", description: "An orange", price: 4.0})
Repo.insert(%Item{name: "Egg", description: "An egg", price: 1.0})
Repo.insert(%Item{name: "Meat", description: "Meat", price: 10.0})
Repo.insert(%Item{name: "Cheese", description: "Cheese", price: 8.0})
Repo.insert(%Item{name: "Coke", description: "Coke", price: 6.0})
Repo.insert(%Item{name: "Pepsi", description: "Pepsi", price: 7.0})
Repo.insert(%Item{name: "Water", description: "Water", price: 1.0})

# insert a cart
Repo.insert(%Cart{})

# insert some cart items
Repo.insert(%CartItem{cart_id: 1, item_id: 1, quantity: 1})
Repo.insert(%CartItem{cart_id: 1, item_id: 2, quantity: 5})
Repo.insert(%CartItem{cart_id: 1, item_id: 3, quantity: 2})

# insert another cart
Repo.insert(%Cart{})

# insert another cart items
Repo.insert(%CartItem{cart_id: 2, item_id: 5, quantity: 2})
Repo.insert(%CartItem{cart_id: 2, item_id: 6, quantity: 10})
