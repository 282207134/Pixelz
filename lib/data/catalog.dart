import 'models.dart';

const categories = [
  ('Graphics & Design', 'category-design'),
  ('Digital Marketing', 'category-marketing'),
  ('Writing & Translation', 'category-writing'),
  ('Video & Animation', 'category-video'),
  ('Music & Audio', 'category-music'),
  ('Programming & Tech', 'category-tech'),
  ('Data', 'category-data'),
  ('Business', 'category-business'),
];
const services = [
  Service(
    'mars',
    'I will custom design for your mobile app, website, and dashboard',
    'service-mars',
    'Graphics & Design',
    price: 50,
  ),
  Service(
    'web',
    'I will create a modern website for your creative business',
    'service-web',
    'Graphics & Design',
  ),
  Service(
    '3d',
    'I will create a beautiful 3D model for your project',
    'welcome-3d',
    'Graphics & Design',
  ),
  Service(
    'logo',
    'I will design a unique logo and brand identity',
    'logo-design',
    'Graphics & Design',
  ),
  Service(
    'code',
    'I will build a responsive website and mobile app',
    'web-design',
    'Programming & Tech',
    price: 80,
  ),
  Service(
    'marketing',
    'I will create a digital strategy to grow your business',
    'category-marketing',
    'Digital Marketing',
    price: 35,
  ),
  Service(
    'writing',
    'I will write engaging content for your website',
    'category-writing',
    'Writing & Translation',
    price: 25,
  ),
  Service(
    'video',
    'I will edit a cinematic video for your brand',
    'category-video',
    'Video & Animation',
    price: 60,
  ),
  Service(
    'music',
    'I will compose original music for your next project',
    'category-music',
    'Music & Audio',
    price: 40,
  ),
  Service(
    'data',
    'I will turn your data into clear business insights',
    'category-data',
    'Data',
    price: 45,
  ),
  Service(
    'business',
    'I will help you build a practical business plan',
    'category-business',
    'Business',
    price: 55,
  ),
];
const contacts = [
  ('Avril Lavigne', 'avatar-avril'),
  ('Daninoveri', 'avatar-dani'),
  ('Chelsea Cutler', 'avatar-chelsea'),
];
const serviceDescription =
    'Bring your ideas to life with thoughtful, custom design. I create clear, engaging experiences for mobile apps, websites, and dashboards. Every project includes responsive layouts, carefully crafted details, and a collaborative design process.';
const packageNames = [
  'Premium Design & Code',
  'Standard Design',
  'Basic Design',
];
double packagePrice(Service service, int index) =>
    (service.price * [5, 3, 1][index] * 100).round() / 100;
