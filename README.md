### Prerequisites
- Ruby 4.0+
- PostgreSQL 14+

### Installation
1. **Clone and Install**:
```bash
bundle install
```

2. **Database Setup**:
```bash
bin/rails db:prepare
```
*Note: `db:prepare` will handle database creation, migrations, and seeding using the professional ingestion tool.*

3. **Start the Server**:
```bash
bin/rails s
```

---

## API Reference

### Restaurants
- `GET /api/v1/restaurants` - List all restaurants with nested menus.
- `GET /api/v1/restaurants/:id` - Detailed view of a single restaurant.

### Menus
- `GET /api/v1/menus` - List all menus across the system.
- `GET /api/v1/menus/:id` - View a specific menu with its items and prices.

---

## JSON → Application Model Conversion Tool

The application includes a specialized conversion tool to serialize and persist data from `json` files into the restaurant menu system.

### How to Run:
The tool is exposed via a HTTP endpoint. To perform a conversion, ensure the server is running and submit a POST request with your JSON payload:

```bash
curl -X POST -H "Content-Type: application/json" \
     -d @restaurant_data.json \
     http://localhost:3000/api/v1/ingestions
```

---

## Testing

```bash
bundle exec rspec --format documentation
```
