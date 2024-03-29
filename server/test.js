const data = [
    { house_id: 3, user_id: 1 },
    { house_id: 3, user_id: 1 },
    { house_id: 3, user_id: 1 },
    { house_id: 2, user_id: 3 },
    { house_id: 1, user_id: 2 },
    { house_id: 2, user_id: 1 },
    { house_id: 3, user_id: 3 }
];

function getHouseRecommendations(userId, data, numRecommendations = 3) {
    // Filtrer les données pour obtenir les maisons visitées par l'utilisateur donné
    const visitedHouses = data.filter(item => item.user_id === userId)
                              .map(item => item.house_id);

    // Compter la fréquence de chaque maison visitée
    const houseFrequency = visitedHouses.reduce((acc, houseId) => {
        acc[houseId] = (acc[houseId] || 0) + 1;
        return acc;
    }, {});

    // Trier les maisons par fréquence décroissante
    const sortedHouses = Object.keys(houseFrequency).sort((a, b) => houseFrequency[b] - houseFrequency[a]);

    // Retourner les meilleures recommandations (maisons non visitées par l'utilisateur)
    const recommendations = sortedHouses.filter(houseId => !visitedHouses.includes(Number(houseId)))
                                        .slice(0, numRecommendations)
                                        .map(houseId => ({ house_id: Number(houseId) }));

    return recommendations.length > 0 ? recommendations : "Aucune recommandation disponible pour cet utilisateur.";
}

// Exemple d'utilisation
const userId = 1;
const recommendations = getHouseRecommendations(userId, data);
console.log(`Recommandations pour l'utilisateur ${userId}:`, recommendations);
