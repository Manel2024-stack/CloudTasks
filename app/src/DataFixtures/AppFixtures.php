<?php

namespace App\DataFixtures;

use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class AppFixtures extends Fixture
{
    private UserPasswordHasherInterface $hasher;

    public function __construct(UserPasswordHasherInterface $hasher)
    {
        $this->hasher = $hasher;
    }

    public function load(ObjectManager $manager): void
    {
        $user = new User();
        $user->setEmail('admin@cloudtasks.fr');
        $user->setRoles(['ROLE_ADMIN']);
        $user->setNom('Administrateur'); 
        $user->setPassword(
            $this->hasher->hashPassword($user, 'password')
        );

        $manager->persist($user);
        $manager->flush();
    }
}
