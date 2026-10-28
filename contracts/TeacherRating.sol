pragma solidity ^0.4.24;

contract TeacherRating {
    struct Teacher {
        string name;
        uint256 totalScore;
        uint256 ratingCount;
    }

    address public owner;
    uint256 public teacherCount;
    
    mapping(uint256 => Teacher) public teachers;
    // La clé de la sécurité : bloque le double vote
    mapping(uint256 => mapping(address => bool)) public hasRated;

    event TeacherAdded(uint256 teacherId, string name);
    event RatingSubmitted(uint256 teacherId, address student, uint8 rating);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // Fonction pour l'Admin (Ajouter un prof)
    function addTeacher(string _name) public onlyOwner {
        teachers[teacherCount] = Teacher(_name, 0, 0);
        emit TeacherAdded(teacherCount, _name);
        teacherCount++;
    }

    // Fonction pour les Étudiants (Voter)
    function rateTeacher(uint256 _teacherId, uint8 _rating) public {
        require(_teacherId < teacherCount, "Professeur inexistant");
        require(_rating >= 1 && _rating <= 5, "Note invalide");
        require(!hasRated[_teacherId][msg.sender], "Deja note");

        hasRated[_teacherId][msg.sender] = true;
        teachers[_teacherId].totalScore += _rating;
        teachers[_teacherId].ratingCount++;

        emit RatingSubmitted(_teacherId, msg.sender, _rating);
    }

    // Statistique publique : calcul de la moyenne
    function getAverage(uint256 _teacherId) public view returns (uint256) {
        if (teachers[_teacherId].ratingCount == 0) return 0;
        // On multiplie par 100 pour avoir 2 décimales (ex: 450 = 4.50)
        return (teachers[_teacherId].totalScore * 100) / teachers[_teacherId].ratingCount;
    }
}