# EduvateKids - Educational Platform

Next.js educational platform with Firebase backend and automatic GitHub deployment.

## 🚀 Live Site

**https://eduvatekids-store.web.app**

## 📱 Pages

- **Home:** `/` - Main landing page
- **Login:** `/auth/login` - Firebase authentication
- **Dashboard:** `/dashboard` - Protected admin dashboard (requires login)

## 🔐 Authentication

To access the dashboard:

1. **Create a user in Firebase Console:**
   - Visit: https://console.firebase.google.com/u/0/project/eduvatekids-store/authentication/users
   - Click "Add user"
   - Enter email and password
   - Click "Add user"

2. **Login:**
   - Go to: https://eduvatekids-store.web.app/auth/login
   - Enter your credentials
   - Access dashboard

## 💻 Local Development

```bash
npm install
npm run dev
```

Visit: http://localhost:8050

## 🔗 URLs

- **Live:** https://eduvatekids-store.web.app
- **GitHub:** https://github.com/ismailukman/EduvateKids
- **Firebase:** https://console.firebase.google.com/u/0/project/eduvatekids-store

## 🚀 Automatic Deployment

### How It Works:
Every push to `master` branch automatically:
1. ✅ Builds the Next.js application
2. ✅ Runs all tests
3. ✅ Deploys to Firebase Hosting
4. ✅ Updates live site

### Deployment Status:
Check: https://github.com/ismailukman/EduvateKids/actions

## 📦 Project Structure

```
app/
├── .github/workflows/     # GitHub Actions
├── app/                   # Next.js app directory
│   ├── auth/login/       # Login page
│   ├── dashboard/        # Dashboard page
│   └── components/       # React components
├── lib/                  # Utilities and configs
│   └── firebase.ts       # Firebase configuration
├── public/               # Static assets
├── assets/               # Images and media
├── firebase.json         # Firebase config
├── firestore.rules       # Database rules
└── next.config.js        # Next.js config
```

## 🛠️ Available Scripts

```bash
# Development
npm run dev          # Start dev server (port 8050)

# Production
npm run build        # Build for production
npm run start        # Start production server
npm run export       # Export static site

# Firebase
firebase login       # Login to Firebase
firebase deploy      # Deploy everything
firebase deploy --only hosting    # Deploy hosting only
firebase deploy --only firestore  # Deploy Firestore rules
```

## 🔥 Firebase Services Used

- **Hosting** - Static site hosting
- **Firestore** - NoSQL database
- **Authentication** - User authentication
- **Analytics** - Usage analytics

## 📱 Features

- ✅ User Authentication
- ✅ Dashboard with Analytics
- ✅ Responsive Design
- ✅ Firebase Integration
- ✅ Auto-deployment via GitHub Actions
- ✅ Firestore Database
- ✅ Analytics Tracking

## 🔒 Security

- Environment variables stored securely
- Firestore rules protect data
- Authentication required for protected routes
- GitHub secrets encrypted

## 📝 Development Workflow

1. **Make changes locally**
   ```bash
   npm run dev
   # Test at http://localhost:8050
   ```

2. **Commit changes**
   ```bash
   git add .
   git commit -m "Your message"
   ```

3. **Push to GitHub**
   ```bash
   git push origin master
   ```

4. **Automatic deployment**
   - GitHub Actions builds and deploys
   - Check status in Actions tab
   - Live site updates automatically

## 🆘 Troubleshooting

### Build Fails
- Check GitHub Actions logs
- Verify all secrets are set
- Ensure .env.local exists locally

### Firestore Permission Denied
- Check authentication status
- Review firestore.rules
- Deploy rules: `firebase deploy --only firestore:rules`

### Can't Access Site
- Wait for deployment to complete
- Check Firebase Console
- Clear browser cache

## 📞 Support

- **Firebase Console:** https://console.firebase.google.com/u/0/project/eduvatekids-store
- **GitHub Repo:** https://github.com/ismailukman/EduvateKids
- **GitHub Actions:** https://github.com/ismailukman/EduvateKids/actions

## 📄 License

Private - All rights reserved

## 👥 Contributing

This is a private project. Contact the owner for contribution guidelines.

---

**Built with:**
- Next.js 14.2.16
- React 18.3.1
- Firebase 12.8.0
- TypeScript 5.4.5
- Tailwind CSS 3.4.4

**Last Updated:** 2026-01-17
