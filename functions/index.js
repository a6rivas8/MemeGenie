const functions = require('firebase-functions');

const admin = require('firebase-admin');
var serviceAccount = require('./Key/serviceAcct.json')
admin.initializeApp({
	credential: admin.credential.cert(serviceAccount),
	databaseURL: 'https://memegenie-ae7bf.firebaseio.com'
});

exports.updateRank = functions.https.onRequest((req, res) => {
	const db = admin.firestore();

	db.collection("memes")
		.get()
		.then(function(querySnapshot) {
			querySnapshot.forEach(function(doc) {
				const var refreshInt = 45000;
				var data = doc.data();
				
				var likes = data.likes;
				var passes = data.passes;
				var diff = likes - passes;

				var score = 0;
				if ((likes - passes) > 0) {
					score = 1;
				} else  if ((likes - passes) === 0) {
					score = 0;
				} else {
					score = -1;
				}

				var maximal = (Math.abs(diff) >= 1) ? (Math.abs(diff)) : 1;
				console.log("Current rank: ", data.rank);

				var rank = Math.log10(maximal) + (score * data.date_uploaded._seconds) / refreshInt;
				console.log("RANK <rank>: ", rank);

				var memeRef = db.collection('memes').doc(doc.id);
				memeRef.update({
					rank: rank
				});

				console.log(doc.id, " => ", doc.data());
			});

			return null;
		})
		.catch(function(error) {
			console.log("Error getting documents: ", error);
		});

	res.redirect(200);
});
