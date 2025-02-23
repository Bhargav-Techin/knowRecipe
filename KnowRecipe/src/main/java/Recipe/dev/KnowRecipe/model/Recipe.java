package Recipe.dev.KnowRecipe.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
public class Recipe {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private String title;

    @ManyToOne
    private User user;
    private String image;

    @Column(length = 500)
    private String description;
    private boolean veg;
    private LocalDateTime createAt;
    private List<Long> likes = new ArrayList<>();
}
