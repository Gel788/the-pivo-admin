# Модели данных

## User

```javascript
{
  _id: ObjectId,
  email: String,
  password: String, // хэшированный
  name: String,
  role: String, // 'user' | 'admin'
  createdAt: Date,
  updatedAt: Date
}
```

## Product

```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  price: Number,
  category: ObjectId, // ссылка на Category
  images: [String],
  isAvailable: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

## Category

```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  parent: ObjectId, // ссылка на родительскую категорию
  createdAt: Date,
  updatedAt: Date
}
```

## Order

```javascript
{
  _id: ObjectId,
  user: ObjectId, // ссылка на User
  items: [{
    product: ObjectId, // ссылка на Product
    quantity: Number,
    price: Number // цена на момент заказа
  }],
  status: String, // 'pending' | 'processing' | 'delivered' | 'cancelled'
  totalAmount: Number,
  deliveryAddress: {
    street: String,
    city: String,
    zipCode: String
  },
  createdAt: Date,
  updatedAt: Date
}
```

## Rating

```javascript
{
  _id: ObjectId,
  user: ObjectId, // ссылка на User
  product: ObjectId, // ссылка на Product
  order: ObjectId, // ссылка на Order
  rating: Number, // 1-5
  comment: String,
  createdAt: Date,
  updatedAt: Date
}
```

## Индексы

### User
- email (уникальный)
- role

### Product
- name
- category
- isAvailable

### Category
- name
- parent

### Order
- user
- status
- createdAt

### Rating
- user
- product
- order 