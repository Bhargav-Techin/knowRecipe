package Recipe.dev.KnowRecipe.service;

import Recipe.dev.KnowRecipe.model.User;
import Recipe.dev.KnowRecipe.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.Optional;

@Service
public class UserService {

        @Autowired
        private UserRepository userRepository;


        public User findUserById(Long userId) throws Exception{
            Optional<User> user = userRepository.findById(userId);
            if (user.isPresent()){
                return user.get();
            }
            throw new Exception("user not found!!");
        }


        public User createUser(User user) throws Exception{
            User isExist=userRepository.findByEmail(user.getEmail());
            if (isExist!=null){
                throw new Exception("email is already exist!!");
            }

            return userRepository.save(user);
        }

        public String deleteUser(Long userId) throws Exception{

            Optional<User> isExist=userRepository.findById(userId);
            if (isExist.isEmpty()){
                throw new Exception("no user with this id");
            }
            userRepository.deleteById(userId);
            return "User deleted successfully";
        }
}
