import re

with open('index.html', 'r', encoding='utf-8') as f:
    content = f.read()

images = [
    'https://images.unsplash.com/photo-1610030470217-cfb5f63cf9fb?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1608748010899-18f300247112?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1583391733956-6c78276477e1?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1609357605129-26f69add5d6e?auto=format&fit=crop&w=300&q=80',
    'https://images.unsplash.com/photo-1583391733956-6c78276477e1?auto=format&fit=crop&w=300&q=80'
]

idx = 0
def repl(m):
    global idx
    img = f'<img src="{images[idx % len(images)]}" alt="Category">'
    idx += 1
    return f'<div class="cat-circle">\n          {img}\n        </div>'

content = re.sub(r'<div class="cat-circle">[\s\S]*?</div>', repl, content)

# Update href="#" to href="shop.html"
content = content.replace('href="#"', 'href="shop.html"')

with open('index.html', 'w', encoding='utf-8') as f:
    f.write(content)
